% BrainSTEM MATLAB API Tutorial
%
% This script demonstrates the recommended workflows using BrainstemClient.
% The client authenticates once and reuses the token for all subsequent calls.
%
% AUTHENTICATION OPTIONS (choose one):
%
%   Option A - Personal Access Token (recommended for scripts / HPC / automation):
%     Create your token at https://www.brainstem.org/private/users/tokens/
%     Then either:
%       setenv('BRAINSTEM_TOKEN','<your_token>')     % set once per MATLAB session
%       client = BrainstemClient();                  % picks it up automatically
%     Or pass it directly:
%       client = BrainstemClient('token','<your_token>');
%
%   Option B - Short-lived JWT tokens (access: 1 h, refresh: 30 days):
%     Tokens renew automatically via the refresh endpoint when they expire.
%     Useful when you cannot store a long-lived PAT.
%       client = BrainstemClient('token_type', 'shortlived');
%     To renew manually:  brainstem.refresh_access_token(url, refresh_token)
%
%   Option C - Interactive login (GUI dialog, desktop MATLAB only):
%       client = BrainstemClient();    % opens credential dialog

client = BrainstemClient();

%% 1. Loading sessions
%  Preferred: use named client methods (tab-completable, credentials automatic)

% Load sessions using the convenience method (includes behaviors, manipulations by default)
output1 = client.load_session();
session = output1.sessions(1);

% Load ALL sessions across all pages automatically
output1_all = client.load_session('load_all', true);

% Filter by name
output1_1 = client.load_session('name', 'Peters session 2');

% Sort descending by name
output1_2 = client.load_session('sort', {'-name'});

% Fetch a single session by UUID
output1_id = client.load_model('session', 'id', 'c5547922-c973-4ad7-96d3-72789f140024');

% Combine filter + sort + include via the generic load_model
output1_6 = client.load_model('session', ...
    'filter',  {'name.icontains', 'Rat'}, ...
    'sort',    {'-name'}, ...
    'include', {'projects'});

%% 2. Updating a session (partial update — only send changed fields)

session = output1.sessions(1);
patch_data.id          = session.id;
patch_data.description = 'updated description';
output2 = client.save_model(patch_data, 'session', 'method', 'patch');

% Full replace (PUT) is still available:
% session.description = 'new description';
% session.tags = [];   % tags is required by the API
% output2_put = client.save_model(session, 'session');

%% 3. Creating a new session

new_session.name        = 'New session 1236567576';
new_session.description = 'new session description';
new_session.projects    = {'0ed470cf-4b48-49f8-b779-10980a8f9dd6'};
new_session.tags        = [];
output3 = client.save_model(new_session, 'session');

%% 4. Deleting a record

% output_del = client.delete_model(output3.id, 'session');

%% 5. Load public projects

output4 = client.load_model('project', 'portal', 'public');

%% 6. Convenience methods on the client (recommended)
%
% These are the preferred entry points — named, tab-completable, and
% automatically use the client's credentials.

output5_1 = client.load_project('name', 'Peters NYU demo project');
output5_2 = client.load_subject('name', 'Peters subject 2');
output5_3 = client.load_session('name', 'mysession');
output5_4 = client.load_behavior('session', 'c5547922-c973-4ad7-96d3-72789f140024');
output5_5 = client.load_dataacquisition('session', 'c5547922-c973-4ad7-96d3-72789f140024');
output5_6 = client.load_manipulation('session', 'c5547922-c973-4ad7-96d3-72789f140024');
output5_7  = client.load_procedure('subject', '274469ce-ccd1-48b1-8631-0a347cee5728');
output5_8  = client.load_collection('name', 'My Collection');
output5_9  = client.load_cohort('name', 'My Cohort');
output5_10 = client.load_subjectlog('subject', '274469ce-ccd1-48b1-8631-0a347cee5728');
output5_11 = client.load_procedurelog('subject', '274469ce-ccd1-48b1-8631-0a347cee5728');
output5_12 = client.load_equipment('session', 'c5547922-c973-4ad7-96d3-72789f140024');
output5_13 = client.load_consumablestock('subject', '274469ce-ccd1-48b1-8631-0a347cee5728');

% The package functions are also available directly when you need them:
output5_pkg = brainstem.load_session('name', 'mysession');

%% 7. Using load_model directly (for models without a convenience method)

% Get all subjects with related procedures
output_subjects = client.load_subject('include', {'procedures'});

% Get all projects with related subjects and sessions
output_projects = client.load_project('include', {'sessions','subjects'});

% Get consumable resources (no convenience loader — use load_model directly)
output_consumables = client.load_model('consumable', 'app', 'resources');

% Paginate manually (first 50, then next 50)
output_page1 = client.load_session('limit', 50, 'offset', 0);
output_page2 = client.load_session('limit', 50, 'offset', 50);
