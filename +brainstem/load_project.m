function output = load_project(varargin)
% LOAD_PROJECT  Load project(s) from BrainSTEM.
%
%   Parameters: name, id, description, sessions, subjects, tags,
%               portal, filter, sort, include, limit, offset, load_all, settings
%
%   Examples:
%     output = load_project()
%     output = load_project('name', 'My Project')
%     output = load_project('id', '<uuid>')
d = struct('app','stem', 'model','project');
d.include = {'sessions','subjects','collections','cohorts'};
output = brainstem_convenience_load(d, ...
    {'id','name','description','sessions','subjects','tags'}, ...
    {'id','id'; 'name','name.icontains'; 'sessions','sessions.id'; ...
     'subjects','subjects.id'; 'tags','tags'}, ...
    varargin{:});
