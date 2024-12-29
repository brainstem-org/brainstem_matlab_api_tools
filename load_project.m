function output = load_project(varargin)
% Load project(s) from BrainSTEM

% Example calls:
% output = load_project('id','ee57e766-fc0c-42e1-9277-7d40d6e9353a');
% output = load_project('name','Peters Project');
% output = load_project('filter',{'id','ee57e766-fc0c-42e1-9277-7d40d6e9353a'});
% output = load_project('tags','1')

p = inputParser;
addParameter(p,'portal','private',@ischar); % private, public, admin
addParameter(p,'app','stem',@ischar); % stem, modules, personal_attributes, resources, taxonomies, dissemination, users
addParameter(p,'model','project',@isstruct); % project, subject, session, collection, ...
addParameter(p,'settings',load_settings,@isstr);
addParameter(p,'filter',{},@iscell); % Filter parameters
addParameter(p,'sort',{},@iscell); % Sorting parameters
addParameter(p,'include',{'sessions','subjects','collections','cohorts'},@iscell); % Embed relational fields

% Project fields (extra parameters)
addParameter(p,'id','',@ischar); % id of project
addParameter(p,'name','',@ischar); % name of project
addParameter(p,'description','',@ischar); % description of project
addParameter(p,'sessions','',@ischar); % sessions
addParameter(p,'subjects','',@ischar); % subjects
addParameter(p,'tags','',@ischar); % tags of project (id of tag)
addParameter(p,'is_public','',@islogical); % project is public

parse(p,varargin{:})
parameters = p.Results;

% Filter query parameters
extra_parameters = {'id','name','description','sessions','subjects','tags','is_public'};
for i = 1:length(extra_parameters)
    if ~isempty(parameters.(extra_parameters{i}))
        switch extra_parameters{i}
            case 'id'
                parameters.filter = [parameters.filter; {'id',parameters.(extra_parameters{i})}];
            case 'name'
                parameters.filter = [parameters.filter; {'name.icontains',parameters.(extra_parameters{i})}];
            case 'sessions'
                parameters.filter = [parameters.filter; {'sessions.id',parameters.(extra_parameters{i})}];
            case 'subjects'
                parameters.filter = [parameters.filter; {'subjects.id',parameters.(extra_parameters{i})}];
            case 'tags'
                parameters.filter = [parameters.filter; {'tags',parameters.(extra_parameters{i})}];
            otherwise
                parameters.filter = [parameters.filter; {[extra_parameters{i},'.icontains'],parameters.(extra_parameters{i})}];
        end
    end
end

output = load_model('portal',parameters.portal,'app',parameters.app,'model',parameters.model,'settings',parameters.settings,'sort',parameters.sort,'filter',parameters.filter,'include',parameters.include);
