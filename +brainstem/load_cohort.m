function output = load_cohort(varargin)
% LOAD_COHORT  Load cohort(s) from BrainSTEM.
%
%   Examples:
%     output = load_cohort();
%     output = load_cohort('name','My Cohort');
%     output = load_cohort('id','<uuid>');

p = inputParser;
addParameter(p,'portal',  'private',             @ischar);
addParameter(p,'app',     'stem',                @ischar);
addParameter(p,'model',   'cohort',              @ischar);
addParameter(p,'settings',load_settings,         @isstruct);
addParameter(p,'filter',  {},                    @iscell);
addParameter(p,'sort',    {},                    @iscell);
addParameter(p,'include', {'subjects'},          @iscell);
addParameter(p,'id',          '', @ischar);
addParameter(p,'name',        '', @ischar);
addParameter(p,'description', '', @ischar);
addParameter(p,'tags',        '', @ischar);
parse(p, varargin{:})
parameters = p.Results;

extra_fields = {'id','name','description','tags'};
filter_map   = {'id','id'; 'name','name.icontains'; 'tags','tags'};
parameters.filter = brainstem_apply_field_filters(parameters, extra_fields, filter_map);

output = load_model('portal',parameters.portal,'app',parameters.app,'model',parameters.model, ...
    'settings',parameters.settings,'sort',parameters.sort, ...
    'filter',parameters.filter,'include',parameters.include);
