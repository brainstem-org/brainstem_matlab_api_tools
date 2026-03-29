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
addParameter(p,'model','project',@ischar); % project, subject, session, collection, ...
addParameter(p,'settings',load_settings,@isstruct);
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

extra_fields = {'id','name','description','sessions','subjects','tags','is_public'};
filter_map = {'id',          'id'; ...
              'name',        'name.icontains'; ...
              'sessions',    'sessions.id'; ...
              'subjects',    'subjects.id'; ...
              'tags',        'tags'};
parameters.filter = brainstem_apply_field_filters(parameters, extra_fields, filter_map);

output = load_model('portal',parameters.portal,'app',parameters.app,'model',parameters.model, ...
    'settings',parameters.settings,'sort',parameters.sort, ...
    'filter',parameters.filter,'include',parameters.include);
