function output = load_subjectlog(varargin)
% LOAD_SUBJECTLOG  Load subject log record(s) from BrainSTEM.
%
%   Subject logs are linked to subjects, not sessions.
%
%   Parameters: subject, id, type, description,
%               portal, filter, sort, include, limit, offset, load_all, settings
%
%   Examples:
%     output = load_subjectlog()
%     output = load_subjectlog('subject', '<subject_uuid>')
%     output = load_subjectlog('type', 'Weighing')
d = struct('app','modules', 'model','subjectlog');
output = brainstem_convenience_load(d, ...
    {'id','subject','type','description'}, ...
    {'id','id'; 'subject','subject.id'; 'type','type'; ...
     'description','description.icontains'}, ...
    varargin{:});
