function output = load_manipulation(varargin)
% LOAD_MANIPULATION  Load manipulation record(s) from BrainSTEM.
%
%   Examples:
%     output = load_manipulation();
%     output = load_manipulation('session','<session_uuid>');
%     output = load_manipulation('id','<uuid>');

p = inputParser;
addParameter(p,'portal',  'private',             @ischar);
addParameter(p,'app',     'modules',             @ischar);
addParameter(p,'model',   'manipulation',        @ischar);
addParameter(p,'settings',load_settings,         @isstruct);
addParameter(p,'filter',  {},                    @iscell);
addParameter(p,'sort',    {},                    @iscell);
addParameter(p,'include', {},                    @iscell);
addParameter(p,'id',          '', @ischar);
addParameter(p,'session',     '', @ischar);
addParameter(p,'tags',        '', @ischar);
parse(p, varargin{:})
parameters = p.Results;

extra_fields = {'id','session','tags'};
filter_map   = {'id','id'; 'session','session.id'; 'tags','tags'};
parameters.filter = brainstem_apply_field_filters(parameters, extra_fields, filter_map);

output = load_model('portal',parameters.portal,'app',parameters.app,'model',parameters.model, ...
    'settings',parameters.settings,'sort',parameters.sort, ...
    'filter',parameters.filter,'include',parameters.include);
