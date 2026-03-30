function logout(url)
% LOGOUT  Remove the cached BrainSTEM token for a given server URL.
%
%   brainstem.logout()        removes the token for https://www.brainstem.org/
%   brainstem.logout(url)     removes the token for the specified server URL
%
%   If the BRAINSTEM_TOKEN environment variable is set, it is not modified
%   here — clear it manually with setenv('BRAINSTEM_TOKEN', '').

if nargin < 1 || isempty(url)
    url = getenv('BRAINSTEM_URL');
    if isempty(url)
        url = 'https://www.brainstem.org/';
    end
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
