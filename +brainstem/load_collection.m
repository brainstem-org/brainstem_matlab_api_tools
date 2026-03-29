function output = load_collection(varargin)
% LOAD_COLLECTION  Load collection(s) from BrainSTEM.
%
%   Examples:
%     output = load_collection();
%     output = load_collection('name','My Collection');
%     output = load_collection('id','<uuid>');

p = inputParser;
addParameter(p,'portal',  'private',            @ischar);
addParameter(p,'app',     'stem',               @ischar);
addParameter(p,'model',   'collection',         @ischar);
addParameter(p,'settings',load_settings,        @isstruct);
addParameter(p,'filter',  {},                   @iscell);
addParameter(p,'sort',    {},                   @iscell);
addParameter(p,'include', {'sessions'},         @iscell);
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
