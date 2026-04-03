function logout(varargin)
% LOGOUT  Remove the cached BrainSTEM token for a given server URL.
%
%   brainstem.logout()                   removes the token for https://www.brainstem.org/
%   brainstem.logout(url)                positional form
%   brainstem.logout('url', url)         name-value form
%
%   If the BRAINSTEM_TOKEN environment variable is set, it is not modified
%   here — clear it manually with setenv('BRAINSTEM_TOKEN', '').

default_url = getenv('BRAINSTEM_URL');
if isempty(default_url)
    default_url = 'https://www.brainstem.org/';
end

if nargin == 0
    url = default_url;
elseif nargin == 1
    url = char(varargin{1});
elseif nargin == 2 && strcmpi(varargin{1}, 'url')
    url = char(varargin{2});
else
    error('brainstem:logout:invalidInput', ...
        'Usage: brainstem.logout() or brainstem.logout(url) or brainstem.logout(''url'', url)');
end

auth_path = fullfile(prefdir, 'brainstem_authentication.mat');

if ~exist(auth_path, 'file')
    fprintf('No saved credentials found for %s\n', url);
    return
end

credentials = load(auth_path, 'authentication');
auth_tbl    = credentials.authentication;
idx         = find(strcmp(url, auth_tbl.urls));

if isempty(idx)
    fprintf('No saved token found for %s\n', url);
    return
end

auth_tbl(idx, :) = [];
authentication   = auth_tbl; %#ok<NASGU>
save(auth_path, 'authentication');

fprintf('Logged out: token for %s removed.\n', url);
end
