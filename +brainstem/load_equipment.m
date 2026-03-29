function output = load_equipment(varargin)
% LOAD_EQUIPMENT  Load equipment record(s) from BrainSTEM.
%
%   Examples:
%     output = load_equipment();
%     output = load_equipment('name','My Tetrode Drive');
%     output = load_equipment('session','<session_uuid>');
%     output = load_equipment('id','<uuid>');

p = inputParser;
addParameter(p,'portal',  'private',             @ischar);
addParameter(p,'app',     'modules',             @ischar);
addParameter(p,'model',   'equipment',           @ischar);
addParameter(p,'settings',load_settings,         @isstruct);
addParameter(p,'filter',  {},                    @iscell);
addParameter(p,'sort',    {},                    @iscell);
addParameter(p,'include', {},                    @iscell);
addParameter(p,'id',      '',                    @ischar);
addParameter(p,'name',    '',                    @ischar);
addParameter(p,'session', '',                    @ischar);
addParameter(p,'tags',    '',                    @ischar);
parse(p, varargin{:})
parameters = p.Results;

extra_fields = {'id','name','session','tags'};
filter_map   = {'id',      'id'; ...
                'name',    'name.icontains'; ...
                'session', 'session.id'; ...
                'tags',    'tags'};
parameters.filter = brainstem_apply_field_filters(parameters, extra_fields, filter_map);

output = load_model('portal',parameters.portal,'app',parameters.app,'model',parameters.model, ...
    'settings',parameters.settings,'sort',parameters.sort, ...
    'filter',parameters.filter,'include',parameters.include);
