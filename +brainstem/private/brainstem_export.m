function output = brainstem_export(model, record_id, varargin)
% BRAINSTEM_EXPORT  Shared implementation of export_project and export_session.
%
%   output = brainstem_export(model, record_id, 'background', tf, 'file', path, ...)
%
%   model is 'project' or 'session'. Direct exports GET
%   /api/private/stem/<model>/<id>/export/ (format 2.1 JSON). With 'background', the
%   export is queued as a server job (POST .../export/), polled at
%   .../export-jobs/<job_id>/ and downloaded (gzip) when it completes, as the Python
%   client's export_project(background=True) does. Errors raise BrainSTEM:export.

p = inputParser;
addParameter(p, 'background',    false, @islogical);
addParameter(p, 'file',          '',    @ischar);
addParameter(p, 'poll_interval', 5,     @(x) isnumeric(x) && isscalar(x) && x > 0);
addParameter(p, 'timeout',       3600,  @(x) isnumeric(x) && isscalar(x) && x > 0);
addParameter(p, 'settings',      [],    @(x) isempty(x) || isstruct(x));
parse(p, varargin{:});
opts = p.Results;
if isempty(opts.settings)
    opts.settings = brainstem_get_settings();
end
if isempty(record_id) || ~ischar(record_id)
    error('BrainSTEM:export', '%s_id is required to export a %s.', model, model);
end
if isempty(opts.settings.token)
    error('BrainSTEM:export', ...
        'A token is required to export. Set BRAINSTEM_API_TOKEN or call brainstem.get_token().');
end

base = brainstem_build_url(opts.settings.url, 'private', 'stem', model, record_id);  % .../<id>/
headers = {'Authorization', ['Bearer ' opts.settings.token]};

if ~opts.background
    options = weboptions('HeaderFields', headers, 'ContentType', 'text', 'Timeout', 90);
    try
        raw = webread([base 'export/'], options);
    catch ME
        status = brainstem_http_status(ME);
        if isequal(status, 503) || isequal(status, 504)
            error('BrainSTEM:export', ['The export did not finish within the server''s request time ' ...
                'limit. Use export_%s(..., ''background'', true) for large exports.'], model);
        end
        rethrow_export_error(ME, model, record_id);
    end
    raw = char(raw);
    bytes = unicode2native(raw, 'UTF-8');
else
    options = weboptions('HeaderFields', headers, 'MediaType', 'application/json', ...
                         'ContentType', 'json', 'RequestMethod', 'post', 'Timeout', 30);
    try
        resp = webwrite([base 'export/'], struct(), options);
    catch ME
        rethrow_export_error(ME, model, record_id);
    end
    job = resp.export_job;
    job_url = sprintf('%sexport-jobs/%s/', base, job.id);
    get_options = weboptions('HeaderFields', headers, 'ContentType', 'json', 'Timeout', 30);
    deadline = tic;
    while any(strcmp(job.status, {'pending', 'running'}))
        if toc(deadline) > opts.timeout
            error('BrainSTEM:export', 'Export job %s did not finish within %g seconds (status: %s).', ...
                job.id, opts.timeout, job.status);
        end
        pause(opts.poll_interval);
        try
            resp = webread(job_url, get_options);
        catch ME
            rethrow_export_error(ME, model, record_id);
        end
        job = resp.export_job;
    end
    if ~strcmp(job.status, 'completed')
        msg = '';
        if isfield(job, 'error_message') && ~isempty(job.error_message), msg = job.error_message; end
        if isempty(msg), msg = sprintf('Export job ended as ''%s''.', job.status); end
        error('BrainSTEM:export', '%s', msg);
    end
    download_url = job.download_url;
    if ~isempty(regexp(download_url, '^https?://', 'once'))
        url = download_url;
    else
        url = [opts.settings.url, regexprep(download_url, '^/', '')];
    end
    bin_options = weboptions('HeaderFields', headers, 'ContentType', 'binary', 'Timeout', 90);
    try
        bytes = webread(url, bin_options);
    catch ME
        rethrow_export_error(ME, model, record_id);
    end
    bytes = uint8(bytes(:))';
    if numel(bytes) >= 2 && bytes(1) == 31 && bytes(2) == 139   % gzip magic number
        if isfield(job, 'file_sha256') && ~isempty(job.file_sha256) && ...
                ~strcmpi(sha256_hex(bytes), job.file_sha256)
            error('BrainSTEM:export', 'Export job %s: downloaded file failed its checksum.', job.id);
        end
        if ~isempty(opts.file) && endsWith(opts.file, '.gz')
            write_bytes(opts.file, bytes);
            opts.file = '';
        end
        bytes = gunzip_bytes(bytes);
    end
    raw = native2unicode(bytes, 'UTF-8');
end

if ~isempty(opts.file)
    if endsWith(opts.file, '.gz')
        tmp = [tempname '.json'];
        write_bytes(tmp, bytes);
        gzip(tmp);
        movefile([tmp '.gz'], opts.file);
        delete(tmp);
    else
        write_bytes(opts.file, bytes);
    end
end

output = jsondecode(raw);
end


function rethrow_export_error(ME, model, record_id)
status = brainstem_http_status(ME);
detail = brainstem_parse_api_error(ME);
switch status
    case 401
        error('BrainSTEM:auth', 'API token is invalid or expired. Call brainstem.get_token() to log in again.');
    case 404
        error('BrainSTEM:export', ['No %s %s that you can read. Exporting needs read access ' ...
            '(the record must be in a project you are a member of).'], model, record_id);
    case 403
        error('BrainSTEM:export', 'You are not allowed to export %s %s: %s', model, record_id, detail);
    case 429
        error('BrainSTEM:export', 'Export rate limit reached (30 per hour): %s', detail);
    otherwise
        error('BrainSTEM:export', 'API error exporting %s %s: %s', model, record_id, detail);
end
end


function write_bytes(path, bytes)
fid = fopen(path, 'w');
if fid < 0, error('BrainSTEM:export', 'Cannot write %s', path); end
cleanup = onCleanup(@() fclose(fid));
fwrite(fid, bytes, 'uint8');
end


function bytes = gunzip_bytes(gz_bytes)
tmp = [tempname '.gz'];
write_bytes(tmp, gz_bytes);
cleanup = onCleanup(@() delete(tmp));
out_dir = tempname;
mkdir(out_dir);
files = gunzip(tmp, out_dir);
fid = fopen(files{1}, 'r');
bytes = fread(fid, inf, 'uint8=>uint8')';
fclose(fid);
delete(files{1});
rmdir(out_dir);
end


function hex = sha256_hex(bytes)
md = java.security.MessageDigest.getInstance('SHA-256');
md.update(typecast(uint8(bytes(:)'), 'int8'));
digest = typecast(md.digest(), 'uint8');
hex = lower(reshape(dec2hex(digest, 2)', 1, []));
end
