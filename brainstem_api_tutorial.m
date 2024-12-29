% 0. Setup credentials/token. User email and password will be requested to generate the token.

get_token

% The token is saved to a mat file, brainstem_authentication.mat, in the Matlab API tool folder.

%% 1. Loading sessions

% load_model can be used to load any model:
output1 = load_model('model','session');

% We can fetch a single session entry from the loaded models.
session = output1.sessions(1);

% We can also filter the models by providing cell array with paired filters
% In this example, it will just load sessions whose name is "yeah".
output1_1 = load_model('model','session','filter',{'name','Peters session 2'});

% Loaded models can be sorted by different criteria applying to their fields. 
% In this example, sessions will be sorted in descending ording according to their name.
output1_2 = load_model('model','session','sort',{'-name'});

% In some cases models contain relations with other models, and they can be also loaded 
% with the models if requested. In this example, all the projects, data acquisition, 
% behaviors and  manipulations related to each session will be included.
output1_3 = load_model('model','session','include',{'projects','dataacquisition','behaviors','manipulations'});

% The list of related data acquisition can be retrived from the returned dictionary.
dataacquisition = output1_3.dataacquisition;

% Get all subjects with related procedures
output1_4 = load_model('model','subject','include',{'procedures'});

% Get all projects with related subjects and sessions
output1_5 = load_model('model','project','include',{'sessions','subjects'});

% All these options can be combined to suit the requirements of the users. For example, we can get only the session that
% contain the word "Rat" in their name, sorted in descending order by their name and including the related projects.
output1_6 = load_model('model','session', 'filter',{'name.icontains', 'Rat'}, 'sort',{'-name'}, 'include',{'projects'});


%% 2. Updating a session

% We can make changes to a model and update it in the database. In this case, we changed the description of
% one of the previously loaded sessions
session = output1.sessions(1);
session.description = 'new description';

% Clearing empty fiels before submitting
fn = fieldnames(session);
tf = cellfun(@(c) isempty(session.(c)), fn);
session = rmfield(session, fn(tf));
session.tags = []; % Tags is a required field

% Submitting changes to session
output2 = save_model('data',session,'model','session');


%% 3. Creating a new session

% We can submit a new entry by defining a dictionary with the required fields.
session = {};
session.name = 'New session 1236567576';
session.description = 'new session description';
session.projects = {'0ed470cf-4b48-49f8-b779-10980a8f9dd6'};
session.tags = [];

% Submitting session
output3 = save_model('data',session,'model','session');


%% 4. Load public projects

% Request the public data by defining the portal to be public
output4 = load_model('model','project','portal','public');


%% 5. Convenience functions for projects, subjects, and sessions

% Loading a project by its name
output5_1 = load_project('name','Peters NYU demo project');

% Loading a subject by its name
output5_2 = load_subject('name','Peters subject 2');

% Loading a session by its name
output5_3 = load_session('name','mysession');
