function output = stem_load_model(varargin)
% Load database model from BrainSTEM

p = inputParser;
addParameter(p,'portal','private',@ischar); % private, public, admin
addParameter(p,'app','stem',@ischar); % stem, modules, personal_attributes, resources, taxonomies, attributes, users
addParameter(p,'model','dataset',@ischar); % project, subject, dataset, collection, ...
addParameter(p,'settings',stem_load_settings,@isstr);
parse(p,varargin{:})
parameters = p.Results;

% Example calls:
% output = stem_load_model('app','stem','model','dataset');
% output = stem_load_model('app','stem','model','project');
% output = stem_load_model('app','resources','model','consumable');
% output = stem_load_model('app','personal_attributes','model','physicalenvironment')

% Settings options
options = weboptions('HeaderFields',{'Authorization',parameters.settings.credentials});
% options = weboptions('Username',stem_settings.credentials.username,'Password',stem_settings.credentials.password,'RequestMethod','get','Timeout',50,'ContentType','json','CertificateFilename','default');
% options = weboptions('HeaderFields',{'Authorization',['Basic ' matlab.net.base64encode([parameters.settings.credentials.username ':' parameters.settings.credentials.password])]});

% Sending request to the REST API
output = webread([parameters.settings.address,parameters.portal,'/',parameters.app,'/',parameters.model],options,'format','json');
