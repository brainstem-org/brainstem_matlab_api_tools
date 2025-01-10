function settings = load_settings
% function for loading local settings used for connecting to BrainSTEM

% url to server
settings.url = 'https://www.brainstem.org/';
% settings.url = 'https://brainstem-development.herokuapp.com/';
% settings.url = 'http://127.0.0.1:8000/';

% Authentication info
if exist('brainstem_authentication.mat','file')
    credentials1 = load('brainstem_authentication.mat','authentication');
    idx = find(ismember(settings.url,credentials1.authentication.urls));
    if isempty(idx)
        settings.token = get_token(settings.url);
    else
        settings.token = credentials1.authentication.tokens{idx};
    end
else
    settings.token = get_token(settings.url);
end

% Local storage
settings.storage = brainstem_local_storage;
