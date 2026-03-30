function output = load_cohort(varargin)
% LOAD_COHORT  Load cohort(s) from BrainSTEM.
%
%   Parameters: name, id, description, tags,
%               portal, filter, sort, include, limit, offset, load_all, settings
%
%   Examples:
%     output = load_cohort()
%     output = load_cohort('name', 'My Cohort')
%     output = load_cohort('id', '<uuid>')
d = struct('app','stem', 'model','cohort');
d.include = {'subjects'};
output = brainstem_convenience_load(d, ...
    {'id','name','description','tags'}, ...
    {'id','id'; 'name','name.icontains'; 'tags','tags'}, ...
    varargin{:});
