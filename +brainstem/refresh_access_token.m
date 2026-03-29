function new_access = refresh_access_token(url, refresh_token_str)
% REFRESH_ACCESS_TOKEN  Silently renew a short-lived access token.
%
%   new_access = refresh_access_token(url, refresh_token)
%
%   Calls POST /api/auth/token/refresh/ and returns a new access token.
%   The stored credentials in prefdir are updated automatically with both
%   the new access token and the new refresh token — the previous refresh
%   token is invalidated by the server on each use.
%
%   This is called automatically by load_settings and BrainstemClient when
%   a short-lived access token has expired and a refresh token is available.
%   For manual use, prefer BrainstemClient which handles all token management.
%
%   See also: brainstem.get_token, BrainstemClient

options = weboptions( ...
    'MediaType',    'application/json', ...
    'ContentType',  'json', ...
    'RequestMethod','post');

json_data = jsonencode(struct('refresh', refresh_token_str));
try
    response = webwrite([url, 'api/auth/token/refresh/'], json_data, options);
catch ME
    error('BrainSTEM:refreshToken', ...
        'Failed to refresh access token: %s', brainstem_parse_api_error(ME));
end

new_access  = response.access;
new_refresh = response.refresh;  % rotated — old refresh token is now invalid
expires_in  = 3600;
if isfield(response, 'expires_in')
    expires_in = response.expires_in;
end

% Update the saved credentials entry for this URL
auth_path = fullfile(prefdir, 'brainstem_authentication.mat');
if exist(auth_path, 'file')
    existing = load(auth_path, 'authentication');
    tbl      = existing.authentication;
    idx      = find(strcmp(url, tbl.urls));
    if ~isempty(idx)
        tbl.tokens{idx}  = new_access;
        if ismember('refresh_tokens', tbl.Properties.VariableNames)
            tbl.refresh_tokens{idx} = new_refresh;
        end
        if ismember('expires_at', tbl.Properties.VariableNames)
            tbl.expires_at{idx} = now + expires_in / 86400;
        end
        if ismember('saved_at', tbl.Properties.VariableNames)
            tbl.saved_at{idx} = now;
        end
        authentication = tbl; %#ok<NASGU>
        save(auth_path, 'authentication');
    end
end
end
