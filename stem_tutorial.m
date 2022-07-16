% 0. Setup credentials
stem_set_basic_authorization 
% This will show a dialog allowing you to input your username (email) and password


%% 1. Loading datasets

% stem_load_model can be used to load any model:
output1 = stem_load_model('model','dataset');

% Load a single entry from the results
dataset = output1.datasets(1);

% Filter by name
output1 = stem_load_model('model','dataset','filter',{'name','yeah'});

% Sort by name
output1 = stem_load_model('model','dataset','sort',{'-name'});

% Get all datasets with related details
output1 = stem_load_model('model','dataset','include',{'projects','experiment_data','behaviors','manipulations'});


%% 2. Updating a dataset

dataset = output1.datasets(1);
dataset.description = 'new description';

% Clearing empty fiels before submitting
fn = fieldnames(dataset);
tf = cellfun(@(c) isempty(dataset.(c)), fn);
dataset = rmfield(dataset, fn(tf));

% Submitting changes to dataset
output2 = stem_save_model('data',dataset,'model','dataset');


%% 3. Creating a new dataset

% Defining required fields
dataset = {};
dataset.name = 'New dataset89';
dataset.description = 'new dataset description';
dataset.projects = {'0c894095-2d16-4bde-ad50-c33b7680417d'};
dataset.user = 1; 

% Submitting dataset
output3 = stem_save_model('data',dataset,'model','dataset');


%% 4. Load public projects

% Request the public data by defining the portal to be public
output4 = stem_load_model('model','project','portal','public');
