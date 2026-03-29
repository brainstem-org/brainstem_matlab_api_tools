function output = load_subjectlog(varargin)
% LOAD_SUBJECTLOG  Load subject log record(s) from BrainSTEM.
%
%   Subject logs have fields: id, type, description, subject.
%   (No session field — subject logs are linked to subjects, not sessions.)
%
%   Examples:
%     output = load_subjectlog();
%     output = load_subjectlog('subject','<subject_uuid>');
%     output = load_subjectlog('type','Weighing');
%     output = load_subjectlog('id','<uuid>');

p = inputParser;
addParameter(p,'portal',      'private',             @ischar);
addParameter(p,'app',         'modules',             @ischar);
addParameter(p,'model',       'subjectlog',          @ischar);
addParameter(p,'settings',    [],                    @(x) isempty(x)||isstruct(x));
addParameter(p,'filter',      {},                    @iscell);
addParameter(p,'sort',        {},                    @iscell);
addParameter(p,'include',     {},                    @iscell);
addParameter(p,'id',          '',                    @ischar);
addParameter(p,'subject',     '',                    @ischar);
addParameter(p,'type',        '',                    @ischar);
addParameter(p,'description', '',                    @ischar);
addParameter(p,'limit',   [],    @(x) isnumeric(x) && isscalar(x));
addParameter(p,'offset',  0,     @(x) isnumeric(x) && isscalar(x));
addParameter(p,'load_all',false, @islogical);
parse(p, varargin{:})
parameters = p.Results;
if isempty(parameters.settings)
    parameters.settings = brainstem.load_settings();
end

extra_fields = {'id','subject','type','description'};
filter_map   = {'id',          'id'; ...
                'subject',     'subject.id'; ...
                'type',        'type'; ...
                'description', 'description.icontains'};
parameters.filter = brainstem_apply_field_filters(parameters, extra_fields, filter_map);

output = brainstem.load('portal',parameters.portal,'app',parameters.app,'model',parameters.model, ...
    'settings',parameters.settings,'sort',parameters.sort, ...
    'filter',parameters.filter,'include',parameters.include, ...
    'limit',parameters.limit,'offset',parameters.offset,'load_all',parameters.load_all);
