function output = load_behavior(varargin)
% LOAD_BEHAVIOR  Load behavior record(s) from BrainSTEM.
%
%   Parameters: session, id,
%               portal, filter, sort, include, limit, offset, load_all, settings
%
%   Examples:
%     output = load_behavior()
%     output = load_behavior('session', '<session_uuid>')
%     output = load_behavior('id', '<uuid>')
d = struct('app','modules', 'model','behavior');
output = brainstem_convenience_load(d, ...
    {'id','session'}, ...
    {'id','id'; 'session','session'}, ...
    varargin{:});
