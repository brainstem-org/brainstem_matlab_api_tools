% BrainSTEM MATLAB API Tools
% Version 2.0  (March 2026)
% https://github.com/brainstem-org/brainstem_matlab_api_tools
%
% Add the repo root to the MATLAB path: addpath('/path/to/brainstem_matlab_api_tools')
% Do NOT add +brainstem/ itself — MATLAB discovers it automatically.
%
% AUTHENTICATION
%   Recommended: set environment variables before starting MATLAB (or in your script):
%     setenv('BRAINSTEM_TOKEN', '<your-personal-access-token>')
%     setenv('BRAINSTEM_URL',   'https://www.brainstem.org/')  % optional, this is the default
%
% MAIN ENTRY POINT
%   BrainstemClient                    - Client class (recommended)
%
% PACKAGE FUNCTIONS  (call as brainstem.<name> or via client methods)
%   brainstem.load                     - Load records from any model
%   brainstem.save                     - Create or update records (POST/PUT/PATCH)
%   brainstem.delete                   - Delete a record by UUID
%   brainstem.get_token                - Acquire and cache an API token via device flow
%   brainstem.get_app_from_model       - Map model name to API app prefix
%
% CONVENIENCE LOADERS  (also available as client.<name>() methods)
%   brainstem.load_project             - Projects  (includes sessions, subjects)
%   brainstem.load_subject             - Subjects  (includes procedures, logs)
%   brainstem.load_session             - Sessions  (includes behaviors, manipulations)
%   brainstem.load_collection          - Collections
%   brainstem.load_cohort              - Cohorts
%   brainstem.load_behavior            - Behavior records
%   brainstem.load_dataacquisition     - Data acquisition records
%   brainstem.load_manipulation        - Manipulation records
%   brainstem.load_procedure           - Procedure records
%   brainstem.load_subjectlog          - Subject log records
%   brainstem.load_procedurelog        - Procedure log records
%   brainstem.load_equipment           - Equipment records
%   brainstem.load_consumablestock     - Consumable stock records
%
% TUTORIAL & TESTS
%   brainstem_api_tutorial             - Example script
%   brainstem.BrainstemTests           - Unit and integration test class (matlab.unittest)

