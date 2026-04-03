function output = load_equipment(varargin)
% LOAD_EQUIPMENT  Load equipment record(s) from BrainSTEM.
%
%   Parameters: name, session, id, tags,
%               portal, filter, sort, include, limit, offset, load_all, settings
%
%   Examples:
%     output = load_equipment()
%     output = load_equipment('name', 'My Tetrode Drive')
%     output = load_equipment('session', '<session_uuid>')
%     output = load_equipment('id', '<uuid>')
d = struct('app','modules', 'model','equipment');
output = brainstem_convenience_load(d, ...
    {'id','name','session','tags'}, ...
    {'id','id'; 'name','name.icontains'; 'session','session.id'; 'tags','tags'}, ...
    varargin{:});
