function output = load_dataacquisition(varargin)
% LOAD_DATAACQUISITION  Load data acquisition record(s) from BrainSTEM.
%
%   Parameters: session, id,
%               portal, filter, sort, include, limit, offset, load_all, settings
%
%   Examples:
%     output = load_dataacquisition()
%     output = load_dataacquisition('session', '<session_uuid>')
%     output = load_dataacquisition('id', '<uuid>')
d = struct('app','modules', 'model','dataacquisition');
output = brainstem_convenience_load(d, ...
    {'id','session'}, ...
    {'id','id'; 'session','session'}, ...
    varargin{:});
