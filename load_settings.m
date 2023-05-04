function settings = load_settings
% function for loading local settings used for connecting to BrainSTEM

% Server path
settings.address = 'https://www.brainstem.org/'; % Public server


% Authentication info
if exist('brainstem_authentication.mat','file')
    credentials1 = load('brainstem_authentication.mat','authentication');
    idx = find(ismember(settings.address,credentials1.authentication.urls));
    if isempty(idx)
        settings.token = get_token(settings.address);
    else
        settings.token = credentials1.authentication.tokens{idx};
    end
else
    settings.token = get_token(settings.address);
end

% Local repositories
settings.repositories = brainstem_local_repositories;
