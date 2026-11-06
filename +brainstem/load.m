function output = load(varargin)
% LOAD  Retrieve records from a BrainSTEM API endpoint.
%
%   output = load('model', MODEL) returns records for MODEL.
%
%   Parameters:
%     model    - Model name, e.g. 'session', 'project', 'subject'  (default: 'session')
%     portal   - 'private' (default) or 'public'
%     app      - App name; auto-detected from model if omitted
%     id       - UUID string; fetches a single record at /<model>/<id>/
%     filter   - Cell array of {field, value} pairs, e.g. {'name.icontains','Rat'}
%     sort     - Cell array of field names; prefix '-' for descending
%     include  - Cell array of relational fields to sideload. Their records come back
%                as extra fields next to the main list, holding only records you may
%                read. Records read this way are marked (see SAVE).
%     limit    - Records per page, 1 to 500 (default 100). Sent as per_page.
%     offset   - Records to skip; must be a multiple of the page size. Sent as page.
%     load_all - true to fetch every page and return all records (default: false).
%                Sideloaded records are merged as well. limit above 500 is reduced
%                to 500, which returns the same records in more pages.
%     settings - Settings struct (auto-resolved from BRAINSTEM_TOKEN env var or token cache)
%
%   Examples:
%     output = brainstem.load('model','session');
%     output = brainstem.load('model','session','id','<session_uuid>');
%     output = brainstem.load('model','session','filter',{'name.icontains','Rat'},'sort',{'-name'});
%     output = brainstem.load('model','session','include',{'behaviors','manipulations'});
%     output = brainstem.load('model','session','load_all',true);
%     output = brainstem.load('model','project','portal','public');

p = inputParser;
addParameter(p,'portal',  'private', @ischar);
addParameter(p,'app',     '',        @ischar);
addParameter(p,'model',   'session', @ischar);
addParameter(p,'id',      '',        @ischar);
addParameter(p,'settings',[],        @(x) isempty(x)||isstruct(x));
addParameter(p,'filter',  {},        @iscell);
addParameter(p,'sort',    {},        @iscell);
addParameter(p,'include', {},        @iscell);
addParameter(p,'limit',   [],        @(x) isempty(x) || (isnumeric(x) && isscalar(x)));
addParameter(p,'offset',  0,         @(x) isnumeric(x) && isscalar(x));
addParameter(p,'load_all',false,     @islogical);
parse(p, varargin{:})
parameters = p.Results;
if isempty(parameters.settings)
    parameters.settings = brainstem_get_settings();
end

% Validate UUID format when an id is supplied
if ~isempty(parameters.id) && isempty(regexp(parameters.id, ...
        '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$', 'once'))
    error('BrainSTEM:load', ...
        'id must be a valid UUID (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx), got: %s', parameters.id);
end

parameters.model = brainstem_resolve_model(parameters.model);
if isempty(parameters.app)
    parameters.app = brainstem.get_app_from_model(parameters.model);
end

% Auth header — omit when token is empty (e.g. public portal requests)
if isempty(parameters.settings.token)
    options = weboptions( ...
        'ContentType',  'json', ...
        'ArrayFormat',  'json', ...
        'Timeout',      30, ...
        'RequestMethod','get');
else
    options = weboptions( ...
        'HeaderFields', {'Authorization', ['Bearer ' parameters.settings.token]}, ...
        'ContentType',  'json', ...
        'ArrayFormat',  'json', ...
        'Timeout',      30, ...
        'RequestMethod','get');
end

% Single-record fetch by id
if ~isempty(parameters.id)
    url = brainstem_build_url(parameters.settings.url, parameters.portal, ...
                              parameters.app, parameters.model, parameters.id);
    try
        output = webread(url, options);
    catch ME
        error('BrainSTEM:load', 'API error fetching %s: %s', url, brainstem_parse_api_error(ME));
    end
    return
end

% Collection fetch
collection_url = brainstem_build_url(parameters.settings.url, parameters.portal, ...
                                     parameters.app, parameters.model);
if ~parameters.load_all
    qs = brainstem_build_query_string(parameters.filter, parameters.sort, ...
                                      parameters.include, parameters.limit, parameters.offset);
    output = fetch_page([collection_url, qs], options);
else
    % Follow page/per_page until meta.total_pages; the server sends no 'next' link.
    page_size = parameters.limit;
    if isempty(page_size), page_size = 100; end
    [page_size, page] = brainstem_page_params(min(page_size, 500), parameters.offset);
    qs = brainstem_build_query_string(parameters.filter, parameters.sort, ...
                                      parameters.include, [], 0);
    if isempty(qs), sep = '?'; else, sep = '&'; end
    output = [];
    while true
        url = sprintf('%s%s%sper_page=%d&page=%d', collection_url, qs, sep, page_size, page);
        page_output = fetch_page(url, options);
        if isempty(output)
            output = page_output;
        else
            output = merge_page(output, page_output);
        end
        total_pages = [];
        if isfield(page_output, 'meta') && isfield(page_output.meta, 'total_pages')
            total_pages = page_output.meta.total_pages;
        end
        if isempty(total_pages) || page >= total_pages || ~page_has_records(page_output)
            break
        end
        page = page + 1;
    end
end

if ~isempty(parameters.include)
    output = mark_included(output, parameters.model, parameters.include);
end
end


function output = fetch_page(url, options)
try
    output = webread(url, options);
catch ME
    error('BrainSTEM:load', 'API error fetching %s: %s', url, brainstem_parse_api_error(ME));
end
output = brainstem_normalize_list_response(output);
end


function output = merge_page(output, page_output)
% Append every record list of a page (the main list and sideloaded ones).
keys = fieldnames(page_output);
for k = 1:numel(keys)
    key = keys{k};
    if strcmp(key, 'meta') || ~is_record_list(page_output.(key))
        continue
    end
    if isfield(output, key)
        output.(key) = brainstem_merge_records(output.(key), page_output.(key));
    else
        output.(key) = page_output.(key);
    end
end
end


function tf = is_record_list(value)
tf = isstruct(value) || iscell(value) || (isnumeric(value) && isempty(value));
end


function tf = page_has_records(page_output)
tf = false;
keys = setdiff(fieldnames(page_output), {'meta'});
for k = 1:numel(keys)
    value = page_output.(keys{k});
    if (isstruct(value) || iscell(value)) && ~isempty(value)
        tf = true;
        return
    end
end
end


function output = mark_included(output, model, include)
% Record on each main record which list fields were read with include: those lists
% hold only the related records the user may read, and SAVE warns before sending them.
key = brainstem_response_key(model);
if ~isfield(output, key)
    keys = setdiff(fieldnames(output), {'meta'});
    if numel(keys) ~= 1
        return
    end
    key = keys{1};
end
records = output.(key);
included = reshape(include, 1, []);
if isstruct(records) && ~isempty(records)
    [records.brainstem_included] = deal(included);
elseif iscell(records)
    for i = 1:numel(records)
        if isstruct(records{i})
            records{i}.brainstem_included = included;
        end
    end
end
output.(key) = records;
end
