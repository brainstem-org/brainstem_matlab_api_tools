function output = load_consumablestock(varargin)
% LOAD_CONSUMABLESTOCK  Load consumable stock record(s) from BrainSTEM.
%
%   Parameters: inventory, id,
%               portal, filter, sort, include, limit, offset, load_all, settings
%
%   Examples:
%     output = load_consumablestock()
%     output = load_consumablestock('inventory', '<inventory_uuid>')
%     output = load_consumablestock('id', '<uuid>')
d = struct('app','modules', 'model','consumablestock');
output = brainstem_convenience_load(d, ...
    {'id','inventory'}, ...
    {'id','id'; 'inventory','inventory'}, ...
    varargin{:});
