function output = delete(id, model, varargin)
% DELETE  Delete a record from a BrainSTEM API endpoint.
%
%   output = delete(ID, MODEL)
%   output = delete(ID, MODEL, 'portal', 'private', 'settings', settings)
%
%   Parameters:
%     id       - UUID string of the record to delete (required)
%     model    - Model name, e.g. 'session', 'project', 'subject' (required)
%     portal   - 'private' (default) or 'public'
%     app      - App name; auto-detected from model if omitted
%     settings - Settings struct (auto-resolved from BRAINSTEM_TOKEN env var or token cache)
%
%   Example:
%     brainstem.delete('<session_uuid>', 'session');

p = inputParser;
addParameter(p,'portal',  'private',    @ischar);
addParameter(p,'app',     '',           @ischar);
addParameter(p,'settings',[],           @(x) isempty(x)||isstruct(x));
parse(p, varargin{:})
parameters = p.Results;
if isempty(parameters.settings)
    parameters.settings = brainstem_get_settings();
end

% Guard against deleting the collection endpoint by accident
if isempty(id)
    error('BrainSTEM:delete', 'id must be a non-empty UUID string.');
end
if isempty(regexp(id, '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$', 'once'))
    error('BrainSTEM:delete', ...
        'id must be a valid UUID (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx), got: %s', id);
end

if isempty(parameters.app)
    parameters.app = brainstem.get_app_from_model(model);
end

if isempty(parameters.settings.token)
    error('BrainSTEM:delete', ...
        'A token is required to delete records. Set BRAINSTEM_TOKEN or call brainstem.get_token().');
end

options = weboptions( ...
    'HeaderFields', {'Authorization', ['Bearer ' parameters.settings.token]}, ...
    'ContentType',  'json', ...
    'Timeout',      30, ...
    'RequestMethod','delete');

endpoint = brainstem_build_url(parameters.settings.url, parameters.portal, ...
                               parameters.app, model, id);
try
    output = webread(endpoint, options);
catch ME
    % A 204 No Content response is a successful delete; webread raises an
    % error for non-200 responses, so tolerate the expected 204 case.
    if contains(ME.message, '204')
        output = struct('status', 'deleted', 'id', id);
    else
        error('BrainSTEM:delete', 'API error deleting %s %s: %s', ...
              model, id, brainstem_parse_api_error(ME));
    end
end
