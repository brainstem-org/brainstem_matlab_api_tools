function output = load_session(varargin)
% LOAD_SESSION  Load session(s) from BrainSTEM.
%
%   Parameters: name, id, description, projects, datastorage, tags,
%               portal, filter, sort, include, limit, offset, load_all, settings
%   'tags' filters by tag name (sent as filter{tags.name}); records return tags as names.
%
%   Examples:
%     output = load_session()
%     output = load_session('name', 'My Session')
%     output = load_session('projects', '<project_uuid>')
%     output = load_session('id', '<uuid>')
d = struct('app','stem', 'model','session');
d.include = {'dataacquisition','behaviors','manipulations','epochs'};
output = brainstem_convenience_load(d, ...
    {'id','name','description','projects','datastorage','tags'}, ...
    {'id','id'; 'name','name.icontains'; 'projects','projects'; ...
     'datastorage','datastorage'; 'tags','tags.name'}, ...
    varargin{:});
