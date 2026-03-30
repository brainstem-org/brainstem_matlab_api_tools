function output = load_subject(varargin)
% LOAD_SUBJECT  Load subject(s) from BrainSTEM.
%
%   Parameters: name, id, description, projects, sex, strain, tags,
%               portal, filter, sort, include, limit, offset, load_all, settings
%
%   Examples:
%     output = load_subject()
%     output = load_subject('name', 'My Subject')
%     output = load_subject('sex', 'M')  % M: Male, F: Female, U: Unknown
%     output = load_subject('strain', '<strain_uuid>')
d = struct('app','stem', 'model','subject');
d.include = {'procedures','subjectlogs'};
output = brainstem_convenience_load(d, ...
    {'id','name','description','projects','strain','sex','tags'}, ...
    {'id','id'; 'name','name.icontains'; 'projects','projects.id'; ...
     'strain','strain.id'; 'sex','sex'; 'tags','tags'}, ...
    varargin{:});
