% BrainSTEM MATLAB API Tools
% Version 2.1  (October 2026)
% https://github.com/brainstem-org/brainstem_matlab_api_tools
%
% Add the repo root to the MATLAB path: addpath('/path/to/brainstem_matlab_api_tools')
% Do NOT add +brainstem/ itself — MATLAB discovers it automatically.
%
% AUTHENTICATION
%   Recommended: set the environment variables shared by all BrainSTEM tools before
%   starting MATLAB (or in your script); the older BRAINSTEM_TOKEN/BRAINSTEM_URL still work:
%     setenv('BRAINSTEM_API_TOKEN', '<your-personal-access-token>')
%     setenv('BRAINSTEM_API_URL',   'https://www.brainstem.org/')  % optional, this is the default
%
% MAIN ENTRY POINT
%   BrainstemClient                    - Client class (recommended)
%
% PACKAGE FUNCTIONS  (call as brainstem.<name> or via client methods)
%   brainstem.load                     - Load records from any model
%   brainstem.save                     - Create or update records (POST/PUT/PATCH)
%   brainstem.delete                   - Delete a record by UUID
%   brainstem.export_project           - Download a project's JSON export (format 2.1)
%   brainstem.export_session           - Download one session's JSON export
%   brainstem.agent_reference          - Read a page of the server's public agent reference
%   brainstem.get_token                - Acquire and cache an API token via device flow
%   brainstem.logout                   - Remove the cached token for a server URL
%   brainstem.env_defaults             - Server URL and token from the environment
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

