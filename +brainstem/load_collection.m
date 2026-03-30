function output = load_collection(varargin)
% LOAD_COLLECTION  Load collection(s) from BrainSTEM.
%
%   Parameters: name, id, description, tags,
%               portal, filter, sort, include, limit, offset, load_all, settings
%
%   Examples:
%     output = load_collection()
%     output = load_collection('name', 'My Collection')
%     output = load_collection('id', '<uuid>')
d = struct('app','stem', 'model','collection');
d.include = {'sessions'};
output = brainstem_convenience_load(d, ...
    {'id','name','description','tags'}, ...
    {'id','id'; 'name','name.icontains'; 'tags','tags'}, ...
    varargin{:});

