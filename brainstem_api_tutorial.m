% 0. Setup credentials/token. User email and password will be requested to generate the token.

get_token

% The token is saved to a mat file, brainstem_authentication.mat, in the Matlab API tool folder.

%% 1. Loading datasets

% load_model can be used to load any model:
output1 = load_model('model','dataset');

% We can fetch a single dataset entry from the loaded models.
dataset = output1.datasets(1);

% We can also filter the models by providing cell array with paired filters
% In this example, it will just load datasets whose name is "yeah".
output1_1 = load_model('model','dataset','filter',{'name','Peters dataset 2'});

% Loaded models can be sorted by different criteria applying to their fields. 
% In this example, datasets will be sorted in descending ording according to their name.
output1_2 = load_model('model','dataset','sort',{'-name'});

% In some cases models contain relations with other models, and they can be also loaded 
% with the models if requested. In this example, all the projects, experiment data, 
% behaviors and  manipulations related to each dataset will be included.
output1_3 = load_model('model','dataset','include',{'projects','experimentdata','behaviors','manipulations'});

% The list of related experiment data can be retrived from the returned dictionary.
experiment_data = output1_3.experiment_data;

% Get all subjects with related procedures
output1_4 = load_model('model','subject','include',{'procedures'});

% Get all projects with related subjects and datasets
output1_5 = load_model('model','project','include',{'datasets','subjects'});

% All these options can be combined to suit the requirements of the users. For example, we can get only the dataset that
% contain the word "Rat" in their name, sorted in descending order by their name and including the related projects.
output1_6 = load_model('model','dataset', 'filter',{'name.icontains', 'Rat'}, 'sort',{'-name'}, 'include',{'projects'});


%% 2. Updating a dataset

% We can make changes to a model and update it in the database. In this case, we changed the description of
% one of the previously loaded datasets
dataset = output1.datasets(1);
dataset.description = 'new description';

% Clearing empty fiels before submitting
fn = fieldnames(dataset);
tf = cellfun(@(c) isempty(dataset.(c)), fn);
dataset = rmfield(dataset, fn(tf));
dataset.tags = []; % Tags is a required field

% Submitting changes to dataset
output2 = save_model('data',dataset,'model','dataset');


%% 3. Creating a new dataset

% We can submit a new entry by defining a dictionary with the required fields.
dataset = {};
dataset.name = 'New dataset 1236567576';
dataset.description = 'new dataset description';
dataset.projects = {'0ed470cf-4b48-49f8-b779-10980a8f9dd6'};
dataset.tags = [];

% Submitting dataset
output3 = save_model('data',dataset,'model','dataset');


%% 4. Load public projects

% Request the public data by defining the portal to be public
output4 = load_model('model','project','portal','public');


%% 5. Convenience functions for projects, subjects, and datasets

% Loading a project by its name
output5_1 = load_project('name','Peters NYU demo project');

% Loading a subject by its name
output5_2 = load_subject('name','Peters subject 2');

% Loading a dataset by its name
output5_3 = load_dataset('name','mydataset');
