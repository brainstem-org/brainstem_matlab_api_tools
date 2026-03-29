function output = load_model(varargin)
% LOAD_MODEL  Retrieve records from a BrainSTEM API endpoint.
%
%   output = load_model('model', MODEL) returns records for MODEL.
%
%   Parameters:
%     model    - Model name, e.g. 'session', 'project', 'subject'  (default: 'session')
%     portal   - 'private' (default) or 'public'
%     app      - App name; auto-detected from model if omitted
%     id       - UUID string; fetches a single record at /<model>/<id>/
%     filter   - Cell array of {field, value} pairs, e.g. {'name.icontains','Rat'}
%     sort     - Cell array of field names; prefix '-' for descending
%     include  - Cell array of relational fields to embed
%     limit    - Max records per page (API default: 20, max: 100)
%     offset   - Records to skip (for manual paging)
%     load_all - true to auto-follow pagination and return all records (default: false)
%     settings - Settings struct from load_settings (loaded automatically if omitted)
%
%   Examples:
%     output = load_model('model','session');
%     output = load_model('model','session','id','c5547922-c973-4ad7-96d3-72789f140024');
%     output = load_model('model','session','filter',{'name.icontains','Rat'},'sort',{'-name'});
%     output = load_model('model','session','include',{'behaviors','manipulations'});
%     output = load_model('model','session','load_all',true);
%     output = load_model('model','project','portal','public');

p = inputParser;
addParameter(p,'portal',  'private', @ischar);
addParameter(p,'app',     '',        @ischar);
addParameter(p,'model',   'session', @ischar);
addParameter(p,'id',      '',        @ischar);
addParameter(p,'settings',load_settings, @isstruct);
addParameter(p,'filter',  {},        @iscell);
addParameter(p,'sort',    {},        @iscell);
addParameter(p,'include', {},        @iscell);
addParameter(p,'limit',   [],        @(x) isnumeric(x) && isscalar(x));
addParameter(p,'offset',  0,         @(x) isnumeric(x) && isscalar(x));
addParameter(p,'load_all',false,     @islogical);
parse(p, varargin{:})
parameters = p.Results;

if isempty(parameters.app)
    parameters.app = get_app_from_model(parameters.model);
end

% Auth header
options = weboptions( ...
    'HeaderFields', {'Authorization', ['Bearer ' parameters.settings.token]}, ...
    'ContentType',  'json', ...
    'ArrayFormat',  'json', ...
    'RequestMethod','get');

% Single-record fetch by id
if ~isempty(parameters.id)
    url = brainstem_build_url(parameters.settings.url, parameters.portal, ...
                              parameters.app, parameters.model, parameters.id);
    try
        output = webread(url, options);
    catch ME
        error('BrainSTEM:loadModel', 'API error fetching %s: %s', url, brainstem_parse_api_error(ME));
    end
    return
end

% Collection fetch (with optional pagination)
qs  = brainstem_build_query_string(parameters.filter, parameters.sort, ...
                                   parameters.include, parameters.limit, parameters.offset);
url = [brainstem_build_url(parameters.settings.url, parameters.portal, ...
                           parameters.app, parameters.model), qs];
try
    output = webread(url, options);
catch ME
    error('BrainSTEM:loadModel', 'API error fetching %s: %s', url, brainstem_parse_api_error(ME));
end

% Auto-paginate: keep fetching while there is a 'next' URL
if parameters.load_all
    % Detect the data key dynamically: it is the response field whose
    % value is a struct array (i.e. not the scalar metadata fields).
    metadata_keys = {'count','next','previous'};
    all_keys = fieldnames(output);
    data_keys = all_keys(~ismember(all_keys, metadata_keys));
    if ~isempty(data_keys)
        model_key = data_keys{1};  % e.g. 'sessions', 'dataacquisitions'
    else
        model_key = '';
    end
    while isfield(output, 'next') && ~isempty(output.next)
        try
            next_page = webread(output.next, options);
        catch ME
            error('BrainSTEM:loadModel', 'API error fetching next page: %s', brainstem_parse_api_error(ME));
        end
        % Append records
        if ~isempty(model_key) && isfield(output, model_key) && isfield(next_page, model_key)
            output.(model_key) = [output.(model_key), next_page.(model_key)];
        end
        if isfield(next_page, 'next')
            output.next = next_page.next;
        else
            output.next = [];
        end
    end
end

