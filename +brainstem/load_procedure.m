function output = load_procedure(varargin)
% LOAD_PROCEDURE  Load procedure record(s) from BrainSTEM.
%
%   Parameters: subject, id, tags,
%               portal, filter, sort, include, limit, offset, load_all, settings
%
%   Examples:
%     output = load_procedure()
%     output = load_procedure('subject', '<subject_uuid>')
%     output = load_procedure('id', '<uuid>')
d = struct('app','modules', 'model','procedure');
output = brainstem_convenience_load(d, ...
    {'id','subject','tags'}, ...
    {'id','id'; 'subject','subject.id'; 'tags','tags'}, ...
    varargin{:});
