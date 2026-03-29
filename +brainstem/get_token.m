function token = get_token(url)
% GET_TOKEN  Obtain a Personal Access Token from the BrainSTEM server.
%
%   Uses the browser-based device authorization flow:
%     1. POST /api/auth/device/  →  {state, verification_url, expires_in}
%     2. Opens verification_url in the default browser so the user can log
%        in (including 2FA if enabled).
%     3. Polls GET /api/auth/device/token/?state=<key> until the user
%        completes the web login, then returns the issued token.
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
    resp  = webwrite([url 'api/auth/device/'], struct(), options_post);
    token = device_flow_(url, resp);
catch
    % Server does not support device flow — prompt for manual PAT entry
    token = manual_pat_flow_(url);
end

if ~isempty(token)
    save_token_(url, token);
end
end

% -------------------------------------------------------------------------
function token = device_flow_(url, resp)
state      = resp.state;
auth_url   = resp.verification_url;
expires_in = 300;
if isfield(resp, 'expires_in'), expires_in = resp.expires_in; end

fprintf('\nAuthenticating with BrainSTEM...\n');
fprintf('Opening login page in your browser.\n');
fprintf('If the browser does not open automatically, visit:\n  %s\n\n', auth_url);
try
    web(auth_url, '-browser');
catch
    % Headless or web() unavailable — user must open manually
end

fprintf('Waiting for authentication (timeout: %d s) ...', expires_in);
options_get = weboptions('ContentType','json','RequestMethod','get');
poll_url    = [url 'api/auth/device/token/?state=' state];
deadline    = now + expires_in / 86400;
token       = '';
while now < deadline
    pause(3);
    fprintf('.');
    try
        r = webread(poll_url, options_get);
    catch
        continue
    end
    if ~isfield(r,'status'), continue; end
    switch r.status
        case 'complete'
            token = r.token;
            fprintf('\nAuthenticated successfully.\n\n');
            return
        case 'expired'
            fprintf('\n');
            error('BrainSTEM:deviceAuthExpired', ...
                'Authentication request expired. Please call get_token() again.');
        % 'pending' → keep waiting
    end
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
new_row = table({token}, {''}, {url}, {now}, {'personal'}, {''}, {expires_at}, ...
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
    authentication = new_row; %#ok<NASGU>
end

save(auth_path, 'authentication');
fprintf('Token saved.\n');
end
