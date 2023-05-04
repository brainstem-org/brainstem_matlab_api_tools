function token = get_token(url,username,password)
% Get token from server
% A post request is send to the token URL
%
% Inputs
% url: address to the server. Default : https://www.brainstem.org/
% username: your username
% password: your password

switch nargin
    case 0
        url = 'https://www.brainstem.org/'; % Public server 
        username = '';
        password = '';
    case 1
        username = '';
        password = '';
    case 2
        password = '';
end

% Shows a input dialog if the username and password were not provided as inputs
if nargin < 3
    answer = inputdlg({'Username:','Password:'},'BrainSTEM credentials',[1 60],{username,password});
    if isempty(answer)
        return
    end
    username = answer{1};
    password = answer{2};
end

% json-encoding the username and password
json_data = jsonencode(struct('username',username,'password',password));

% Setting options
options = weboptions('HeaderFields',{'Authorization',''},'MediaType','application/json','ContentType','json','ArrayFormat','json','RequestMethod','post');

% Sending request to the REST API to get the token
response = webwrite([url,'api/token/'],json_data,options);
token = response.token;

tokens = {token};
usernames = {username};
urls = {url};

authentication = table(tokens,usernames,urls);

% Saving the token
[path1,~,~] = fileparts(which('get_token.m'));
save(fullfile(path1,'brainstem_authentication.mat'),'authentication')
disp(['Tokens saved to ', path1, '/brainstem_token.mat'])
