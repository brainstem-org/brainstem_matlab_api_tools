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
addParameter(p,'portal','private',@ischar); % private, public
addParameter(p,'app','stem',@ischar); % stem, modules, personal_attributes, resources, taxonomies, dissemination, users
addParameter(p,'model','subject',@ischar); % project, subject, session, collection, ...
addParameter(p,'settings',load_settings,@isstruct);
addParameter(p,'filter',{},@iscell); % Filter parameters
addParameter(p,'sort',{},@iscell); % Sorting parameters
addParameter(p,'include',{'procedures','subjectlogs'},@iscell); % Embed relational fields

% Subject fields (extra parameters)
addParameter(p,'id','',@ischar); % id of subject
addParameter(p,'name','',@ischar); % name of subject
addParameter(p,'description','',@ischar); % description of subject
addParameter(p,'projects','',@ischar); % projects of subject
addParameter(p,'strain','',@ischar); % strain of subject
addParameter(p,'sex','',@ischar); % sec of subject
addParameter(p,'tags','',@ischar); % tags of project (id of tag)

parse(p,varargin{:})
parameters = p.Results;

extra_fields = {'id','name','description','projects','strain','sex','tags'};
filter_map = {'id',        'id'; ...
              'name',      'name.icontains'; ...
              'projects',  'projects.id'; ...
              'strain',    'strain.id'; ...
              'sex',       'sex'; ...
              'tags',      'tags'};
parameters.filter = brainstem_apply_field_filters(parameters, extra_fields, filter_map);

output = load_model('portal',parameters.portal,'app',parameters.app,'model',parameters.model, ...
    'settings',parameters.settings,'sort',parameters.sort, ...
    'filter',parameters.filter,'include',parameters.include);
