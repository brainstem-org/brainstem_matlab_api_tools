function output = load_model(varargin)
% Load model from BrainSTEM

% Example calls:
% output = load_model('app','stem','model','dataset');
% output = load_model('app','stem','model','project');
% output = load_model('app','resources','model','consumable');
% output = load_model('app','personal_attributes','model','physicalenvironment')

p = inputParser;
addParameter(p,'portal','private',@ischar); % private, public, admin
addParameter(p,'app','',@ischar); % stem, modules, personal_attributes, resources, taxonomies, attributes, users
addParameter(p,'model','dataset',@ischar); % project, subject, dataset, collection, ...
addParameter(p,'settings',load_settings,@isstruct);
addParameter(p,'filter',{},@iscell); % Filter parameters
addParameter(p,'sort',{},@iscell); % Sorting parameters
addParameter(p,'include',{},@iscell); % Embed relational fields
parse(p,varargin{:})
parameters = p.Results;

if isempty(parameters.app)
    parameters.app = get_app_from_model(parameters.model);
end

% Setting query parameters
query_parameters = '';

% Filter query parameters
if ~isempty(parameters.filter)
    for i=1:2:floor(numel(parameters.filter)/2)
        if isempty(query_parameters)
            prefix = '?';
        else
            prefix = '&';            
        end
        query_parameters = [query_parameters,prefix,'filter{',parameters.filter{i}, '}=',urlencode(parameters.filter{i+1})];
    end
end

% Sort query parameters
if ~isempty(parameters.sort)
    for i=1:numel(parameters.sort)
        if isempty(query_parameters)
            prefix = '?';
        else
            prefix = '&';            
        end
        query_parameters = [query_parameters,prefix,'sort[]=',parameters.sort{i}];
    end
end

% Embed relational fields?
if ~isempty(parameters.include)
    for i=1:numel(parameters.include)
        if isempty(query_parameters)
            prefix = '?';
        else
            prefix = '&';            
        end
        query_parameters = [query_parameters,prefix,'include[]=',parameters.include{i},'.*'];
    end
end

% Options
options = weboptions('HeaderFields',{'Authorization',['Bearer ' parameters.settings.token]},'ContentType','json','ArrayFormat','json','RequestMethod','get');

% Defining the url
url = [parameters.settings.address,'api/',parameters.portal,'/',parameters.app,'/',parameters.model,'/',query_parameters];

% Sending request to the REST API
output = webread(url,options);

