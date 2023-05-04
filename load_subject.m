function output = load_subject(varargin)
% Load subject(s) from BrainSTEM

% Example calls:
% output = load_subject('id','274469ce-ccd1-48b1-8631-0a347cee5728');
% output = load_subject('name','Peters subject2');
% output = load_subject('filter',{'id','274469ce-ccd1-48b1-8631-0a347cee5728'});
% output = load_subject('tags','1');
% output = load_subject('sex','M'); % M: Male, F: Female, U: Unknown
% output = load_subject('strain','7d056b05-ff2c-4dda-96f5-e34fe4dc3ac4');

p = inputParser;
addParameter(p,'portal','private',@ischar); % private, public, admin
addParameter(p,'app','stem',@ischar); % stem, modules, personal_attributes, resources, taxonomies, attributes, users
addParameter(p,'model','subject',@isstruct); % project, subject, dataset, collection, ...
addParameter(p,'settings',load_settings,@isstr);
addParameter(p,'filter',{},@iscell); % Filter parameters
addParameter(p,'sort',{},@iscell); % Sorting parameters
addParameter(p,'include',{'actions','subjectstatechanges'},@iscell); % Embed relational fields

% Dataset fields (extra parameters)
addParameter(p,'id','',@ischar); % id of subject
addParameter(p,'name','',@ischar); % name of subject
addParameter(p,'description','',@ischar); % description of subject
addParameter(p,'projects','',@ischar); % projects of subject
addParameter(p,'strain','',@ischar); % strain of subject
addParameter(p,'sex','',@ischar); % sec of subject
addParameter(p,'tags','',@ischar); % tags of project (id of tag)

parse(p,varargin{:})
parameters = p.Results;

% Filter query parameters
extra_parameters = {'id','name','description','projects','strain','sex','tags'};
for i = 1:length(extra_parameters)
    if ~isempty(parameters.(extra_parameters{i}))
        switch extra_parameters{i}
            case 'id'
                parameters.filter = [parameters.filter; {'id',parameters.(extra_parameters{i})}];
            case 'projects'
                parameters.filter = [parameters.filter; {'projects.id',parameters.(extra_parameters{i})}];
            case 'strain'
                parameters.filter = [parameters.filter; {'strain.id',parameters.(extra_parameters{i})}];
            case 'sex'
                parameters.filter = [parameters.filter; {'sex',parameters.(extra_parameters{i})}];
            case 'tags'
                parameters.filter = [parameters.filter; {'tags',parameters.(extra_parameters{i})}];
            otherwise
                parameters.filter = [parameters.filter; {[extra_parameters{i},'.icontains'],parameters.(extra_parameters{i})}];
        end
    end
end

output = load_model('portal',parameters.portal,'app',parameters.app,'model',parameters.model,'settings',parameters.settings,'sort',parameters.sort,'filter',parameters.filter,'include',parameters.include);
