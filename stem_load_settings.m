function stem_settings = stem_load_settings
% function for loading local settings used for connecting to BrainSTEM

% Server path
%stem_settings.address = 'https://www.brainstem.org/rest/'; % Public server
stem_settings.address = 'http://127.0.0.1:8000/rest/'; % Local server

% Authentication info
if exist('stem_credentials_encoded.mat','file')
    credentials1 = load('stem_credentials_encoded.mat','credentials');
    stem_settings.credentials = credentials1.credentials;
elseif exist('stem_credentials.m','file')
    credentials1 = stem_credentials;
    stem_settings.credentials = ['Basic ' matlab.net.base64encode([credentials1.username ':' credentials1.password])];
end

% Local repositories
stem_settings.repositories = stem_local_repositories;
