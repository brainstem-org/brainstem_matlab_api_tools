function token = get_token(url, username, password, token_type)
% GET_TOKEN  Obtain an authentication token from the BrainSTEM server.
%
%   BrainSTEM supports two token types:
%
%     'personal'   (default) — Personal Access Token: long-lived, sliding
%                  1-year window.  Recommended for scripts and automation.
%                  POST /api/token/  →  {access, token_id, message}
%
%     'shortlived' — Short-lived JWT pair: access token (1 hour) + refresh
%                  token (30 days).  The access token is renewed silently
%                  via refresh_access_token when it expires; the refresh
%                  token rotates on each use.
%                  POST /api/auth/token/  →  {access, refresh, expires_in}
%
%   Parameters:
%     url        - Server URL (default: https://www.brainstem.org/)
%     username   - Email / username (prompted via GUI if omitted)
%     password   - Password (prompted via GUI if omitted)
%     token_type - 'personal' (default) or 'shortlived'

if nargin < 1 || isempty(url),        url        = 'https://www.brainstem.org/'; end
if nargin < 2,                         username   = ''; end
if nargin < 3,                         password   = ''; end
if nargin < 4 || isempty(token_type),  token_type = 'personal'; end

token_type = lower(token_type);
if ~ismember(token_type, {'personal','shortlived'})
    error('BrainSTEM:getToken', ...
        'token_type must be ''personal'' or ''shortlived'', got ''%s''.', token_type);
end

% Show GUI dialog if credentials are missing
if isempty(username) || isempty(password)
    answer = passdlg(username);
    if isempty(answer.User{1}) || isempty(answer.Pass{1})
        token = '';
        return
    end
    username = answer.User{1};
    password = answer.Pass{1};
end

options_post = weboptions( ...
    'MediaType',    'application/json', ...
    'ContentType',  'json', ...
    'ArrayFormat',  'json', ...
    'RequestMethod','post');

if strcmp(token_type, 'shortlived')
    % Short-lived JWT: access (1 h) + refresh (30 days)
    % Note: this endpoint uses 'email' as the field name
    json_data     = jsonencode(struct('email', username, 'password', password));
    response      = webwrite([url, 'api/auth/token/'], json_data, options_post);
    token         = response.access;
    refresh_token = response.refresh;
    expires_in    = 3600;
    if isfield(response, 'expires_in')
        expires_in = response.expires_in;
    end
    expires_at = now + expires_in / 86400;
else
    % Personal / backward-compatible: sliding ~1-year PAT
    json_data     = jsonencode(struct('username', username, 'password', password));
    response      = webwrite([url, 'api/token/'], json_data, options_post);
    token         = response.access;
    refresh_token = '';
    expires_at    = now + 365;
end

% --- Persist credentials, preserving any other stored URLs ---------------
auth_path = fullfile(prefdir, 'brainstem_authentication.mat');
new_row = table({token}, {username}, {url}, {now}, {token_type}, ...
                {refresh_token}, {expires_at}, ...
    'VariableNames', {'tokens','usernames','urls','saved_at', ...
                      'token_type','refresh_tokens','expires_at'});

if exist(auth_path, 'file')
    existing = load(auth_path, 'authentication');
    tbl      = existing.authentication;
    % Upgrade old table schemas that are missing new columns
    if ~ismember('token_type',     tbl.Properties.VariableNames)
        tbl.token_type     = repmat({'personal'}, height(tbl), 1);
    end
    if ~ismember('refresh_tokens', tbl.Properties.VariableNames)
        tbl.refresh_tokens = repmat({''},          height(tbl), 1);
    end
    if ~ismember('expires_at',     tbl.Properties.VariableNames)
        if ismember('saved_at', tbl.Properties.VariableNames)
            tbl.expires_at = cellfun(@(t) t + 365, tbl.saved_at, 'UniformOutput', false);
        else
            tbl.expires_at = repmat({now + 365}, height(tbl), 1);
        end
    end
    idx = find(strcmp(url, tbl.urls));
    if ~isempty(idx)
        % Update the existing entry for this URL
        tbl.tokens{idx}         = token;
        tbl.usernames{idx}      = username;
        tbl.saved_at{idx}       = now;
        tbl.token_type{idx}     = token_type;
        tbl.refresh_tokens{idx} = refresh_token;
        tbl.expires_at{idx}     = expires_at;
        authentication = tbl; %#ok<NASGU>
    else
        % New URL — append a row
        authentication = [tbl; new_row]; %#ok<NASGU>
    end
else
    authentication = new_row; %#ok<NASGU>
end

save(auth_path, 'authentication')
disp(['Token saved to ', auth_path])
end
