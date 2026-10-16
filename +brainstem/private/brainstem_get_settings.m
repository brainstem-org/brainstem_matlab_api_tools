function settings = brainstem_get_settings()
% BRAINSTEM_GET_SETTINGS  Build a settings struct for BrainSTEM API calls.
%
%   Resolves URL and token in a well-defined precedence order:
%
%   URL (in order):
%     1. BRAINSTEM_API_URL (shared with the other BrainSTEM tools), else BRAINSTEM_URL
%     2. Default: https://www.brainstem.org/
%
%   Token (in order):
%     1. BRAINSTEM_API_TOKEN (shared with the other BrainSTEM tools), else BRAINSTEM_TOKEN
%     2. Cached token in prefdir/brainstem_authentication.mat
%     3. Interactive device-authorization flow  (opens browser)

[url, env_token] = brainstem_env_settings();
settings.url = url;

% 1. Environment variable — headless / HPC friendly
if ~isempty(env_token)
    settings.token = env_token;
    return
end

% 2. Cached token in prefdir
auth_path = fullfile(prefdir, 'brainstem_authentication.mat');
if exist(auth_path, 'file')
    credentials = load(auth_path, 'authentication');
    auth_tbl    = credentials.authentication;
    idx         = find(strcmp(url, auth_tbl.urls));
    if ~isempty(idx)
        has_expires = ismember('expires_at', auth_tbl.Properties.VariableNames);
        has_saved   = ismember('saved_at',   auth_tbl.Properties.VariableNames);
        if has_expires
            days_left = auth_tbl.expires_at{idx} - now;
        elseif has_saved
            days_left = (auth_tbl.saved_at{idx} + 365) - now;
        else
            days_left = Inf;
        end
        if days_left <= 0
            warning('BrainSTEM:tokenExpired', ...
                'Saved token has expired — re-authenticating.');
            settings.token = brainstem.get_token(url);
        elseif days_left < 15
            warning('BrainSTEM:tokenNearExpiry', ...
                ['BrainSTEM token expires in ~%.0f days. ' ...
                 'Regenerate at %sprivate/users/tokens/'], days_left, url);
            settings.token = auth_tbl.tokens{idx};
        else
            settings.token = auth_tbl.tokens{idx};
        end
        return
    end
end

% 3. No cached token — interactive device-authorization flow
settings.token = brainstem.get_token(url);
end
