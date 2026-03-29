function settings = load_settings
% function for loading local settings used for connecting to BrainSTEM

% url to server
settings.url = 'https://www.brainstem.org/';
% settings.url = 'https://brainstem-development.herokuapp.com/';
% settings.url = 'http://127.0.0.1:8000/';

% Authentication info
auth_path = fullfile(prefdir,'brainstem_authentication.mat');
if exist(auth_path,'file')
    credentials1 = load(auth_path,'authentication');
    % Bug fix: ismember returns scalar 0/1, not the row index.
    % Use strcmp to get the correct index into a multi-URL table.
    idx = find(strcmp(settings.url, credentials1.authentication.urls));
    if isempty(idx)
        settings.token = brainstem.get_token(settings.url);
    else
        auth_tbl = credentials1.authentication;
        % Determine remaining lifetime using expires_at (preferred) or
        % saved_at for backward-compatible old .mat files.
        has_expires = ismember('expires_at',    auth_tbl.Properties.VariableNames);
        has_saved   = ismember('saved_at',       auth_tbl.Properties.VariableNames);
        if has_expires
            days_left = auth_tbl.expires_at{idx} - now;
        elseif has_saved
            days_left = (auth_tbl.saved_at{idx} + 365) - now;  % treat as personal PAT
            is_short  = false;
        else
            days_left = Inf;
        end

        if days_left <= 0
            warning('BrainSTEM:tokenExpired', ...
                'Saved token has expired — re-authenticating.');
            settings.token = brainstem.get_token(settings.url);
        elseif days_left < 15
            % Personal token approaching expiry — warn, but keep using it
            warning('BrainSTEM:tokenNearExpiry', ...
                ['BrainSTEM personal access token expires in ~%.0f days. ' ...
                 'Regenerate at https://www.brainstem.org/private/users/tokens/'], days_left);
            settings.token = auth_tbl.tokens{idx};
        else
            settings.token = auth_tbl.tokens{idx};
        end
    end
else
    settings.token = brainstem.get_token(settings.url);
end

% Local storage (set to empty; configure manually if needed)
settings.storage = {};
