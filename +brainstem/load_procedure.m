function output = load_procedure(varargin)
% LOAD_PROCEDURE  Load procedure record(s) from BrainSTEM.
%
%   Examples:
%     output = load_procedure();
%     output = load_procedure('subject','<subject_uuid>');
%     output = load_procedure('id','<uuid>');

p = inputParser;
addParameter(p,'portal',  'private',             @ischar);
addParameter(p,'app',     'modules',             @ischar);
addParameter(p,'model',   'procedure',           @ischar);
addParameter(p,'settings',load_settings,         @isstruct);
addParameter(p,'filter',  {},                    @iscell);
addParameter(p,'sort',    {},                    @iscell);
addParameter(p,'include', {},                    @iscell);
addParameter(p,'id',          '', @ischar);
addParameter(p,'subject',     '', @ischar);
addParameter(p,'tags',        '', @ischar);
parse(p, varargin{:})
parameters = p.Results;

extra_fields = {'id','subject','tags'};
filter_map   = {'id','id'; 'subject','subject.id'; 'tags','tags'};
parameters.filter = brainstem_apply_field_filters(parameters, extra_fields, filter_map);

output = load_model('portal',parameters.portal,'app',parameters.app,'model',parameters.model, ...
    'settings',parameters.settings,'sort',parameters.sort, ...
    'filter',parameters.filter,'include',parameters.include);
