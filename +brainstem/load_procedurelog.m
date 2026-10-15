function output = load_procedurelog(varargin)
% LOAD_PROCEDURELOG  Load procedure log record(s) from BrainSTEM.
%
%   Parameters: procedure, id,
%               portal, filter, sort, include, limit, offset, load_all, settings
%
%   Examples:
%     output = load_procedurelog()
%     output = load_procedurelog('procedure', '<procedure_uuid>')
%     output = load_procedurelog('id', '<uuid>')
d = struct('app','modules', 'model','procedurelog');
output = brainstem_convenience_load(d, ...
    {'id','procedure'}, ...
    {'id','id'; 'procedure','procedure'}, ...
    varargin{:});
