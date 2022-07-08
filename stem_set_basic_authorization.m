function stem_set_basic_authorization(username,password)
% Save creditials to a base64encoded char
switch nargin
    case 0
        username = '';
        password = '';
    case 1
        password = '';
end

% Shows a input dialog if the username and password were not provided as inputs
if nargin<2
    answer = inputdlg({'Username:','Password:'},'BrainSTEM credentials',[1 60],{username,password});
    username = answer{1};
    password = answer{2};
end

% Generating base64 encoded credentials
credentials = ['Basic ' matlab.net.base64encode([username ':' password])];

% Saving the credentials
[path1,~,~] = fileparts(which('stem_set_basic_authorization.m'));
save(fullfile(path1,'stem_credentials_encoded.mat'),'credentials')

disp('Credentials saved to stem_credentials_encoded.mat')
