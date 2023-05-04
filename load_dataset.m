function output = load_dataset(varargin)
% Load dataset(s) from BrainSTEM

% Example calls:
% output = load_dataset('id','c5547922-c973-4ad7-96d3-72789f140024');
% output = load_dataset('name','New dataset');
% output = load_dataset('filter',{'id','c5547922-c973-4ad7-96d3-72789f140024'});
% output = load_dataset('tags','1')

p = inputParser;
addParameter(p,'portal','private',@ischar); % private, public, admin
addParameter(p,'app','stem',@ischar); % stem, modules, personal_attributes, resources, taxonomies, attributes, users
addParameter(p,'model','dataset',@isstruct); % project, subject, dataset, collection, ...
addParameter(p,'settings',load_settings,@isstr);
addParameter(p,'filter',{},@iscell); % Filter parameters
addParameter(p,'sort',{},@iscell); % Sorting parameters
addParameter(p,'include',{'experimentdata','behaviors','manipulations','epochs'},@iscell); % Embed relational fields

% Dataset fields (extra parameters)
addParameter(p,'id','',@ischar); % id of dataset
addParameter(p,'name','',@ischar); % name of dataset
addParameter(p,'description','',@ischar); % description of dataset
addParameter(p,'projects','',@ischar); % date and time of dataset
addParameter(p,'datarepositories','',@ischar); % datarepository of dataset
addParameter(p,'tags','',@ischar); % tags of dataset (id of tag)

parse(p,varargin{:})
parameters = p.Results;

% Filter query parameters
extra_parameters = {'id','name','description','projects','datarepositories','tags'};
for i = 1:length(extra_parameters)
    if ~isempty(parameters.(extra_parameters{i}))
        switch extra_parameters{i}
            case 'id'
                parameters.filter = [parameters.filter; {'id',parameters.(extra_parameters{i})}];
            case 'name'
                parameters.filter = [parameters.filter; {'name.icontains',parameters.(extra_parameters{i})}];
            case 'projects'
                parameters.filter = [parameters.filter; {'projects.id',parameters.(extra_parameters{i})}];
            case 'datarepositories'
                parameters.filter = [parameters.filter; {'datarepositories.id',parameters.(extra_parameters{i})}];
            case 'tags'
                parameters.filter = [parameters.filter; {'tags',parameters.(extra_parameters{i})}];
            otherwise
                parameters.filter = [parameters.filter; {[extra_parameters{i},'.icontains'],parameters.(extra_parameters{i})}];
        end
    end
end

output = load_model('portal',parameters.portal,'app',parameters.app,'model',parameters.model,'settings',parameters.settings,'sort',parameters.sort,'filter',parameters.filter,'include',parameters.include);
