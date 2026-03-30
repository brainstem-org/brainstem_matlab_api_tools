function token = get_token(url)
% GET_TOKEN  Obtain a Personal Access Token from the BrainSTEM server.
%
%   Uses the browser-based device authorization flow:
%     1. POST /api/auth/device/  →  {session_id, device_code, verification_uri_complete, expires_in}
%     2. Opens verification_uri_complete in the default browser so the user
%        can log in (including 2FA if enabled).
%     3. Polls POST /api/auth/device/token/ with {device_code} until the
%        user completes the web login, then returns the issued token.
%
%   Fallback: if the server does not support the device flow (older
%   deployments), the user is prompted to paste a Personal Access Token
%   obtained from <url>private/users/tokens/.
%
%   Parameters:
%     url - Server base URL (default: https://www.brainstem.org/)
if nargin < 1 || isempty(url)
    url = 'https://www.brainstem.org/';
end

% Attempt device authorization flow
options_post = weboptions( ...
    'MediaType',    'application/json', ...
    'ContentType',  'json', ...
    'RequestMethod','post');
try
    resp = webwrite([url 'api/auth/device/'], struct(), options_post);
catch
    % Server does not support device flow — prompt for manual PAT entry
    token = manual_pat_flow_(url);
    if ~isempty(token)
        save_token_(url, token);
    end
    return
end

token = device_flow_(url, resp);

if ~isempty(token)
    save_token_(url, token);
end
end

% -------------------------------------------------------------------------
function token = device_flow_(url, resp)
device_code = resp.device_code;
auth_url    = resp.verification_uri_complete;
expires_in  = 300;
if isfield(resp, 'expires_in'), expires_in = resp.expires_in; end

fprintf('\nAuthenticating with BrainSTEM...\n');
fprintf('Opening login page in your browser.\n');
fprintf('If the browser does not open automatically, visit:\n  %s\n\n', auth_url);
try
    web(char(auth_url), '-browser');
catch
    % Headless or web() unavailable — user must open manually
end

fprintf('Waiting for authentication (timeout: %d s) ...', expires_in);
options_poll = weboptions( ...
    'MediaType',    'application/json', ...
    'ContentType',  'json', ...
    'RequestMethod','post');
poll_url  = [url 'api/auth/device/token/'];
poll_body = struct('device_code', device_code);
deadline  = now + expires_in / 86400;
token     = '';
while now < deadline
    pause(3);
    fprintf('.');
    try
        r = webwrite(poll_url, poll_body, options_poll);
    catch
        continue
    end
    if isfield(r, 'status') && strcmp(r.status, 'success')
        token = r.token;
        fprintf('\nAuthenticated successfully.\n\n');
        return
    end
    if isfield(r, 'error')
        switch r.error
            case 'expired_token'
                fprintf('\n');
                error('BrainSTEM:deviceAuthExpired', ...
                    'Authentication request expired. Please call get_token() again.');
            case 'access_denied'
                fprintf('\n');
                error('BrainSTEM:deviceAuthDenied', ...
                    'Access denied. Please try again.');
            otherwise
                fprintf('\n');
                error('BrainSTEM:deviceAuthError', ...
                    'Unexpected error: %s', r.error);
        end
    end
    % authorization_pending → keep waiting
end
fprintf('\n');
error('BrainSTEM:deviceAuthTimeout', ...
    'Authentication timed out after %d seconds. Please try again.', expires_in);
end

% -------------------------------------------------------------------------
function token = manual_pat_flow_(url)
tokens_url = [url 'private/users/tokens/'];
fprintf(['\nThis server does not support the device authorization flow.\n' ...
         'To authenticate:\n' ...
         '  1. Open: %s\n' ...
         '  2. Create a Personal Access Token\n' ...
         '  3. Copy the token and paste it below\n\n'], tokens_url);
answer = inputdlg( ...
    {sprintf('Personal Access Token\n(from %s)', tokens_url)}, ...
    'BrainSTEM Authentication', [1 72]);
if isempty(answer) || isempty(strtrim(answer{1}))
    token = '';
else
    token = strtrim(answer{1});
end
end

% -------------------------------------------------------------------------
function save_token_(url, token)
auth_path  = fullfile(prefdir, 'brainstem_authentication.mat');
expires_at = now + 365;   % Personal Access Tokens are valid for ~1 year

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
    if ~ismember('usernames',      tbl.Properties.VariableNames)
        tbl.usernames      = repmat({''},          height(tbl), 1);
    end
    if ~ismember('saved_at',       tbl.Properties.VariableNames)
        tbl.saved_at       = repmat({now},         height(tbl), 1);
    end
    if ~ismember('expires_at',     tbl.Properties.VariableNames)
        if ismember('saved_at', tbl.Properties.VariableNames)
            tbl.expires_at = cellfun(@(t) t + 365, tbl.saved_at, 'UniformOutput', false);
        else
            tbl.expires_at = repmat({now + 365}, height(tbl), 1);
        end
    end
    % Reorder tbl to canonical schema, then build new_row explicitly
    canonical_vars = {'tokens','usernames','urls','saved_at','token_type','refresh_tokens','expires_at'};
    tbl     = tbl(:, canonical_vars);
    new_row = table({token}, {''}, {url}, {now}, {'personal'}, {''}, {expires_at}, ...
        'VariableNames', canonical_vars);

    idx = find(strcmp(url, tbl.urls));
    if ~isempty(idx)
        tbl.tokens{idx}         = token;
        tbl.usernames{idx}      = '';
        tbl.saved_at{idx}       = now;
        tbl.token_type{idx}     = 'personal';
        tbl.refresh_tokens{idx} = '';
        tbl.expires_at{idx}     = expires_at;
        authentication = tbl; %#ok<NASGU>
    else
        authentication = [tbl; new_row]; %#ok<NASGU>
    end
else
    new_row = table({token}, {''}, {url}, {now}, {'personal'}, {''}, {expires_at}, ...
        'VariableNames', {'tokens','usernames','urls','saved_at', ...
                          'token_type','refresh_tokens','expires_at'});
    authentication = new_row; %#ok<NASGU>
end

save(auth_path, 'authentication');
fprintf('Token saved to %s\n', auth_path);
end
