function output = brainstem_convenience_load(model_defaults, extra_fields, filter_map, varargin)
% BRAINSTEM_CONVENIENCE_LOAD  Shared implementation for all load_* functions.
%
%   This private helper eliminates the boilerplate duplicated across the 13
%   load_* convenience functions. Each caller only defines its model-specific
%   configuration and delegates everything else here.
%
%   model_defaults - struct with fields:
%       .app     (required) API app name, e.g. 'stem', 'modules'
%       .model   (required) Model name, e.g. 'session', 'behavior'
%       .include (optional) Default relational fields to embed; default {}
%       .portal  (optional) Default portal; default 'private'
%
%   extra_fields   - cell row vector of loader-specific named parameters,
%                    e.g. {'id','name','session','tags'}.
%                    Each is added to the inputParser with '' default / @ischar.
%
%   filter_map     - n×2 cell array mapping parameter name → API filter key,
%                    e.g. {'id','id'; 'name','name.icontains'; 'tags','tags'}.
%                    Parameters absent from the map default to '<field>.icontains'.
%
%   varargin       - name-value pairs forwarded from the caller.

% Apply model_defaults fallbacks
if ~isfield(model_defaults, 'portal'),  model_defaults.portal  = 'private'; end
if ~isfield(model_defaults, 'include'), model_defaults.include = {};         end

p = inputParser;
addParameter(p, 'portal',   model_defaults.portal,  @ischar);
addParameter(p, 'app',      model_defaults.app,     @ischar);
addParameter(p, 'model',    model_defaults.model,   @ischar);
addParameter(p, 'settings', [],                     @(x) isempty(x) || isstruct(x));
addParameter(p, 'filter',   {},                     @iscell);
addParameter(p, 'sort',     {},                     @iscell);
addParameter(p, 'include',  model_defaults.include, @iscell);
addParameter(p, 'limit',    [],                     @(x) isempty(x) || (isnumeric(x) && isscalar(x)));
addParameter(p, 'offset',   0,                      @(x) isnumeric(x) && isscalar(x));
addParameter(p, 'load_all', false,                  @islogical);
for i = 1:numel(extra_fields)
    addParameter(p, extra_fields{i}, '', @ischar);
end
parse(p, varargin{:});
parameters = p.Results;

if isempty(parameters.settings)
    parameters.settings = brainstem_get_settings();
end

parameters.filter = brainstem_apply_field_filters(parameters, extra_fields, filter_map);

output = brainstem.load( ...
    'portal',   parameters.portal,   ...
    'app',      parameters.app,      ...
    'model',    parameters.model,    ...
    'settings', parameters.settings, ...
    'sort',     parameters.sort,     ...
    'filter',   parameters.filter,   ...
    'include',  parameters.include,  ...
    'limit',    parameters.limit,    ...
    'offset',   parameters.offset,   ...
    'load_all', parameters.load_all);
end
