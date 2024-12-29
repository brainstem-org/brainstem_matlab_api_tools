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
addParameter(p,'model','session',@isstruct); % project, subject, session, collection, ...
addParameter(p,'settings',load_settings,@isstr);
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

parse(p,varargin{:})
parameters = p.Results;

% Filter query parameters
extra_parameters = {'id','name','description','projects','datastorage','tags'};
for i = 1:length(extra_parameters)
    if ~isempty(parameters.(extra_parameters{i}))
        switch extra_parameters{i}
            case 'id'
                parameters.filter = [parameters.filter; {'id',parameters.(extra_parameters{i})}];
            case 'name'
                parameters.filter = [parameters.filter; {'name.icontains',parameters.(extra_parameters{i})}];
            case 'projects'
                parameters.filter = [parameters.filter; {'projects.id',parameters.(extra_parameters{i})}];
            case 'datastorage'
                parameters.filter = [parameters.filter; {'datastorage.id',parameters.(extra_parameters{i})}];
            case 'tags'
                parameters.filter = [parameters.filter; {'tags',parameters.(extra_parameters{i})}];
            otherwise
                parameters.filter = [parameters.filter; {[extra_parameters{i},'.icontains'],parameters.(extra_parameters{i})}];
        end
    end
end

output = load_model('portal',parameters.portal,'app',parameters.app,'model',parameters.model,'settings',parameters.settings,'sort',parameters.sort,'filter',parameters.filter,'include',parameters.include);
