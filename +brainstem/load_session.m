function output = load_session(varargin)
% Load session(s) from BrainSTEM

% Example calls:
% output = load_session('id','c5547922-c973-4ad7-96d3-72789f140024');
% output = load_session('name','New session');
% output = load_session('filter',{'id','c5547922-c973-4ad7-96d3-72789f140024'});
% output = load_session('tags','1')

p = inputParser;
addParameter(p,'portal','private',@ischar); % private, public, admin
addParameter(p,'app','stem',@ischar); % stem, modules, personal_attributes, resources, taxonomies, dissemination, users
addParameter(p,'model','session',@ischar); % project, subject, session, collection, ...
addParameter(p,'settings',[],@(x) isempty(x)||isstruct(x));
addParameter(p,'filter',{},@iscell); % Filter parameters
addParameter(p,'sort',{},@iscell); % Sorting parameters
addParameter(p,'include',{'dataacquisition','behaviors','manipulations','epochs'},@iscell); % Embed relational fields

% Session fields (extra parameters)
addParameter(p,'id','',@ischar); % id of session
addParameter(p,'name','',@ischar); % name of session
addParameter(p,'description','',@ischar); % description of session
addParameter(p,'projects','',@ischar); % date and time of session
addParameter(p,'datastorage','',@ischar); % datastorage of session
addParameter(p,'tags','',@ischar); % tags of session (id of tag)
addParameter(p,'limit',   [],    @(x) isnumeric(x) && isscalar(x));
addParameter(p,'offset',  0,     @(x) isnumeric(x) && isscalar(x));
addParameter(p,'load_all',false, @islogical);parse(p,varargin{:})
parameters = p.Results;
if isempty(parameters.settings)
    parameters.settings = brainstem.load_settings();
end

extra_fields = {'id','name','description','projects','datastorage','tags'};
filter_map = {'id',          'id'; ...
              'name',        'name.icontains'; ...
              'projects',    'projects.id'; ...
              'datastorage', 'datastorage.id'; ...
              'tags',        'tags'};
parameters.filter = brainstem_apply_field_filters(parameters, extra_fields, filter_map);

output = brainstem.load('portal',parameters.portal,'app',parameters.app,'model',parameters.model, ...
    'settings',parameters.settings,'sort',parameters.sort, ...
    'filter',parameters.filter,'include',parameters.include, ...
    'limit',parameters.limit,'offset',parameters.offset,'load_all',parameters.load_all);
