function output = load_equipment(varargin)
% LOAD_EQUIPMENT  Load equipment record(s) from BrainSTEM.
%
%   Parameters: name, setup, id,
%               portal, filter, sort, include, limit, offset, load_all, settings
%
%   Examples:
%     output = load_equipment()
%     output = load_equipment('name', 'My Tetrode Drive')
%     output = load_equipment('setup', '<setup_uuid>')
%     output = load_equipment('id', '<uuid>')
d = struct('app','modules', 'model','equipment');
output = brainstem_convenience_load(d, ...
    {'id','name','setup'}, ...
    {'id','id'; 'name','name.icontains'; 'setup','setup'}, ...
    varargin{:});
