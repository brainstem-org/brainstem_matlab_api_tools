function output = delete_model(id, model, varargin)
% DELETE_MODEL  Delete a record from a BrainSTEM API endpoint.
%
%   output = delete_model(ID, MODEL)
%   output = delete_model(ID, MODEL, 'portal', 'private', 'settings', settings)
%
%   Parameters:
%     id       - UUID string of the record to delete (required)
%     model    - Model name, e.g. 'session', 'project', 'subject' (required)
%     portal   - 'private' (default) or 'public'
%     app      - App name; auto-detected from model if omitted
%     settings - Settings struct from load_settings (loaded automatically if omitted)
%
%   Example:
%     delete_model('c5547922-c973-4ad7-96d3-72789f140024', 'session');

p = inputParser;
addParameter(p,'portal',  'private',    @ischar);
addParameter(p,'app',     '',           @ischar);
addParameter(p,'settings',load_settings,@isstruct);
parse(p, varargin{:})
parameters = p.Results;

if isempty(parameters.app)
    parameters.app = get_app_from_model(model);
end

options = weboptions( ...
    'HeaderFields', {'Authorization', ['Bearer ' parameters.settings.token]}, ...
    'ContentType',  'json', ...
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
        error('BrainSTEM:deleteModel', 'API error deleting %s %s: %s', ...
              model, id, brainstem_parse_api_error(ME));
    end
end
