function output = load_procedurelog(varargin)
% LOAD_PROCEDURELOG  Load procedure log record(s) from BrainSTEM.
%
%   Examples:
%     output = load_procedurelog();
%     output = load_procedurelog('subject','<subject_uuid>');
%     output = load_procedurelog('id','<uuid>');

p = inputParser;
addParameter(p,'portal',    'private',             @ischar);
addParameter(p,'app',       'modules',             @ischar);
addParameter(p,'model',     'procedurelog',        @ischar);
addParameter(p,'settings',  [],                    @(x) isempty(x)||isstruct(x));
addParameter(p,'filter',    {},                    @iscell);
addParameter(p,'sort',      {},                    @iscell);
addParameter(p,'include',   {},                    @iscell);
addParameter(p,'id',        '',                    @ischar);
addParameter(p,'subject',   '',                    @ischar);
addParameter(p,'tags',      '',                    @ischar);
addParameter(p,'limit',   [],    @(x) isnumeric(x) && isscalar(x));
addParameter(p,'offset',  0,     @(x) isnumeric(x) && isscalar(x));
addParameter(p,'load_all',false, @islogical);
parse(p, varargin{:})
parameters = p.Results;
if isempty(parameters.settings)
    parameters.settings = brainstem.load_settings();
end

extra_fields = {'id','subject','tags'};
filter_map   = {'id',      'id'; ...
                'subject', 'subject.id'; ...
                'tags',    'tags'};
parameters.filter = brainstem_apply_field_filters(parameters, extra_fields, filter_map);

output = brainstem.load('portal',parameters.portal,'app',parameters.app,'model',parameters.model, ...
    'settings',parameters.settings,'sort',parameters.sort, ...
    'filter',parameters.filter,'include',parameters.include, ...
    'limit',parameters.limit,'offset',parameters.offset,'load_all',parameters.load_all);
