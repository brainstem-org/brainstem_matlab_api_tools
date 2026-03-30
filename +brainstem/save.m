function output = save(varargin)
% SAVE  Create or update a record in a BrainSTEM API endpoint.
%
%   output = save('data', DATA, 'model', MODEL)
%
%   When DATA contains an 'id' field, an update is performed (PUT or PATCH).
%   Otherwise a new record is created (POST).
%
%   Parameters:
%     data     - Struct with the record fields to submit (required)
%     model    - Model name, e.g. 'session', 'project', 'subject'  (default: 'session')
%     portal   - 'private' (default) or 'public'
%     app      - App name; auto-detected from model if omitted
%     method   - 'put' (default, full replace) or 'patch' (partial update)
%     settings - Settings struct (auto-resolved from BRAINSTEM_TOKEN env var or token cache)
%
%   Examples:
%     % Update an existing session (full replace):
%     output = brainstem.save('data', session, 'model', 'session');
%
%     % Partial update (only send changed fields):
%     output = brainstem.save('data', struct('description','new desc'), ...
%                             'model','session','method','patch');
%
%     % Create a new session:
%     s.name = 'My session'; s.projects = {'<uuid>'}; s.tags = [];
%     output = brainstem.save('data', s, 'model', 'session');

p = inputParser;
addParameter(p,'portal',  'private',    @ischar);
addParameter(p,'app',     '',           @ischar);
addParameter(p,'model',   'session',    @ischar);
addParameter(p,'settings',[],@(x) isempty(x)||isstruct(x));
addParameter(p,'data',    struct(),     @isstruct);
addParameter(p,'method',  'put',        @(x) ismember(lower(x),{'put','patch'}));
parse(p, varargin{:})
parameters = p.Results;
if isempty(parameters.settings)
    parameters.settings = brainstem_get_settings();
end

if isempty(parameters.app)
    parameters.app = brainstem.get_app_from_model(parameters.model);
end

% Validate UUID format when an id is present in data
if isfield(parameters.data, 'id') && ~isempty(parameters.data.id) && ...
        isempty(regexp(parameters.data.id, ...
        '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$', 'once'))
    error('BrainSTEM:save', ...
        'data.id must be a valid UUID (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx), got: %s', parameters.data.id);
end

% PATCH without an id in the data makes no sense: there is no record to update.
has_id = isfield(parameters.data, 'id') && ~isempty(parameters.data.id);
if strcmpi(parameters.method, 'patch') && ~has_id
    error('BrainSTEM:save', '%s', ...
        ['PATCH requires an ''id'' field in data to identify the record. ' ...
         'For new records omit the ''method'' parameter (POST is used automatically).']);
end

if isempty(parameters.settings.token)
    error('BrainSTEM:save', ...
        'A token is required to save records. Set BRAINSTEM_TOKEN or call brainstem.get_token().');
end

options = weboptions( ...
    'HeaderFields', {'Authorization', ['Bearer ' parameters.settings.token]}, ...
    'MediaType',    'application/json', ...
    'ContentType',  'json', ...
    'ArrayFormat',  'json', ...
    'Timeout',      30);

if has_id
    options.RequestMethod = lower(parameters.method);
    endpoint = brainstem_build_url(parameters.settings.url, parameters.portal, ...
                                   parameters.app, parameters.model, parameters.data.id);
else
    options.RequestMethod = 'post';
    endpoint = brainstem_build_url(parameters.settings.url, parameters.portal, ...
                                   parameters.app, parameters.model);
end

try
    output = webwrite(endpoint, parameters.data, options);
    % Normalize an empty response body (some PATCH endpoints return 204 No Content)
    if isempty(output)
        output = parameters.data;
    end
catch ME
    % 204 No Content is a valid success response for PATCH
    if contains(ME.message, '204')
        output = parameters.data;
        return
    end
    api_msg = brainstem_parse_api_error(ME);
    error('BrainSTEM:save', 'API error saving %s to %s: %s', ...
          parameters.model, endpoint, api_msg);
end
