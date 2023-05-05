function output = save_model(varargin)
% Save database model to BrainSTEM

% Example calls:
% output = save_model('data',data,'app','stem','model','dataset');
% output = save_model('data',data,'app','stem','model','project');
% output = save_model('data',data,'app','resources','model','consumable');
% output = save_model('data',data,'app','personal_attributes','model','physicalenvironment')

p = inputParser;
addParameter(p,'portal','private',@ischar); % private, public, admin
addParameter(p,'app','',@ischar); % stem, modules, personal_attributes, resources, taxonomies, attributes, users
addParameter(p,'model','dataset',@ischar); % project, subject, dataset, collection, ...
addParameter(p,'settings',load_settings,@isstr);
addParameter(p,'data',{},@isstruct); % private, public, admin
parse(p,varargin{:})
parameters = p.Results;

if isempty(parameters.app)
    parameters.app = get_app_from_model(parameters.model);
end

% Setting options
options = weboptions('HeaderFields',{'Authorization',['Bearer ' parameters.settings.token]},'MediaType','application/json','ContentType','json','ArrayFormat','json');

if isfield(parameters.data,'id')
    % Setting RequestMethod
    options.RequestMethod = 'put';
    
    % Defining endpoint url:
    brainstem_endpoint = [parameters.settings.url,'api/',parameters.portal,'api/',parameters.app,'/',parameters.model,'/',parameters.data.id,'/'];
else
    % Setting RequestMethod
    options.RequestMethod = 'post';
    
    % Defining endpoint url:
    brainstem_endpoint = [parameters.settings.url,'api/',parameters.portal,'/',parameters.app,'/',parameters.model,'/'];
end

% Sending request to the REST API
output = webwrite(brainstem_endpoint,parameters.data,options);
