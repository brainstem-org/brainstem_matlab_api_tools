function output = load_manipulation(varargin)
% LOAD_MANIPULATION  Load manipulation record(s) from BrainSTEM.
%
%   Parameters: session, id, tags,
%               portal, filter, sort, include, limit, offset, load_all, settings
%
%   Examples:
%     output = load_manipulation()
%     output = load_manipulation('session', '<session_uuid>')
%     output = load_manipulation('id', '<uuid>')
d = struct('app','modules', 'model','manipulation');
output = brainstem_convenience_load(d, ...
    {'id','session','tags'}, ...
    {'id','id'; 'session','session.id'; 'tags','tags'}, ...
    varargin{:});
