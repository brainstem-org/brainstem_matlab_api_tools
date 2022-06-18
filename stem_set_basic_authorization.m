function stem_set_basic_authorization(varargin)
% Save creditials to a base64encoded char, 

p = inputParser;
addParameter(p,'username','private',@ischar);
addParameter(p,'password','stem',@ischar); 
parse(p,varargin{:})

parameters = p.Results;

credentials = ['Basic ' matlab.net.base64encode([parameters.username ':' parameters.password])];

[path1,~,~] = fileparts(which('stem_set_basic_authorization.m'));
save(fullfile(path1,'stem_credentials_encoded.mat'),'credentials')
