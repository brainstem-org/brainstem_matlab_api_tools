classdef BrainstemClient < handle
% BRAINSTEMCLIENT  Client for the BrainSTEM REST API.
%
%   Create a client once per session; it holds the authentication token
%   and base URL so you don't have to pass them to every call.
%
%   CONSTRUCTION
%     client = BrainstemClient()
%       Prompts for credentials (GUI dialog) and stores the returned token.
%
%     client = BrainstemClient('token', TOKEN)
%       Use a Personal Access Token directly (recommended for scripts/HPC).
%       Get your token at https://www.brainstem.org/private/users/tokens/
%       You can also set the environment variable BRAINSTEM_TOKEN and call:
%         client = BrainstemClient('token', getenv('BRAINSTEM_TOKEN'))
%
%     client = BrainstemClient('url', URL)
%       Connect to a non-default server (e.g. local dev instance).
%
%
%   CORE METHODS
%     output = client.load(model, ...)
%     output = client.save(data, model, ...)
%     output = client.delete(id, model, ...)
%
%   CONVENIENCE LOADERS  (named shortcuts with pre-set include defaults)
%     output = client.load_project(...)        'name','id','tags', ...
%     output = client.load_subject(...)        'name','id','sex','strain', ...
%     output = client.load_session(...)        'name','id','projects', ...
%     output = client.load_collection(...)     'name','id','tags'
%     output = client.load_cohort(...)         'name','id','tags'
%     output = client.load_behavior(...)       'session','id','tags'
%     output = client.load_dataacquisition(...)'session','id','tags'
%     output = client.load_manipulation(...)   'session','id','tags'
%     output = client.load_procedure(...)      'subject','id','tags'
%     output = client.load_subjectlog(...)     'subject','type','description','id'
%     output = client.load_procedurelog(...)   'subject','id','tags'
%     output = client.load_equipment(...)      'name','session','id','tags'
%     output = client.load_consumablestock(...)'subject','id','tags'
%
%   LOAD parameters (all optional after model):
%     'portal'   - 'private' (default) or 'public'
%     'id'       - UUID; fetches a single record at /<model>/<id>/
%     'filter'   - cell array {field, value, ...}
%     'sort'     - cell array of fields; prefix '-' for descending
%     'include'  - cell array of relational fields to embed
%     'limit'    - max records per page (API default 20, max 100)
%     'offset'   - records to skip
%     'load_all' - true to auto-follow pagination and return all records
%
%   SAVE parameters (all optional after data and model):
%     'portal'   - 'private' (default) or 'public'
%     'method'   - 'put' (default, full replace) or 'patch' (partial update)
%
%   EXAMPLES
%     % Authenticate with a Personal Access Token stored in an env variable
%     client = BrainstemClient('token', getenv('BRAINSTEM_TOKEN'));
%
%     % Load all sessions (auto-paginate)
%     out = client.load('session', 'load_all', true);
%
%     % Load a single session by ID
%     out = client.load('session', 'id', '<session_uuid>');
%
%     % Filter, sort, embed relations
%     out = client.load('session', ...
%             'filter',  {'name.icontains','Rat'}, ...
%             'sort',    {'-name'}, ...
%             'include', {'behaviors','manipulations'});
%
%     % Update a session (partial update)
%     s.id = out.sessions(1).id;
%     s.description = 'updated';
%     client.save(s, 'session', 'method', 'patch');
%
%     % Create a new session
%     s = struct('name','New session','projects',{{'<proj_uuid>'}},'tags',[]);
%     client.save(s, 'session');
%
%     % Delete a session
%     client.delete(out.sessions(1).id, 'session');
%
%     % Convenience loaders — field-level parameters, sensible include defaults
%     out = client.load_session('name', 'mysession');
%     out = client.load_subject('sex', 'M', 'sort', {'name'});
%     out = client.load_behavior('session', '<session_uuid>');
%     out = client.load_project('name', 'My Project', 'portal', 'public');
%
%     % Load public projects
%     out = client.load('project', 'portal', 'public');

    properties (SetAccess = private)
        url        (1,:) char  = 'https://www.brainstem.org/'
        token      (1,:) char  = ''
        token_type (1,:) char  = 'personal'
    end

    methods
        % ------------------------------------------------------------------
        function obj = BrainstemClient(varargin)
        % BRAINSTEMCLIENT  Constructor.
            p = inputParser;
            addParameter(p, 'url',   'https://www.brainstem.org/', @ischar);
            addParameter(p, 'token', '',                           @ischar);
            parse(p, varargin{:});

            obj.url = p.Results.url;

            if ~isempty(p.Results.token)
                obj.token = p.Results.token;
            else
                % Try environment variable first (headless-friendly)
                env_token = getenv('BRAINSTEM_TOKEN');
                if ~isempty(env_token)
                    obj.token = env_token;
                    disp('BrainstemClient: authenticated via BRAINSTEM_TOKEN environment variable.');
                else
                    % Fall back to saved token or interactive login
                    obj.token = obj.load_or_request_token_();
                end
            end
        end

        % ------------------------------------------------------------------
        function output = load(obj, model, varargin)
        % LOAD  Retrieve records from a BrainSTEM API endpoint.
        %   See class documentation for full parameter list.
            try
                output = brainstem.load('model', model, ...
                                    'settings', obj.settings_(), ...
                                    varargin{:});
            catch ME
                if obj.is_auth_error_(ME)
                    obj.refresh_token_();
                    output = brainstem.load('model', model, ...
                                        'settings', obj.settings_(), ...
                                        varargin{:});
                else
                    rethrow(ME);
                end
            end
        end

        % ------------------------------------------------------------------
        function output = save(obj, data, model, varargin)
        % SAVE  Create or update a BrainSTEM record.
        %   See class documentation for full parameter list.
            try
                output = brainstem.save('data', data, 'model', model, ...
                                    'settings', obj.settings_(), ...
                                    varargin{:});
            catch ME
                if obj.is_auth_error_(ME)
                    obj.refresh_token_();
                    output = brainstem.save('data', data, 'model', model, ...
                                        'settings', obj.settings_(), ...
                                        varargin{:});
                else
                    rethrow(ME);
                end
            end
        end

        % ------------------------------------------------------------------
        function output = delete(obj, id, model, varargin)
        % DELETE  Delete a BrainSTEM record by UUID.
            try
                output = brainstem.delete(id, model, ...
                                      'settings', obj.settings_(), ...
                                      varargin{:});
            catch ME
                if obj.is_auth_error_(ME)
                    obj.refresh_token_();
                    output = brainstem.delete(id, model, ...
                                          'settings', obj.settings_(), ...
                                          varargin{:});
                else
                    rethrow(ME);
                end
            end
        end

        % ------------------------------------------------------------------
        % Convenience loaders — named shortcuts with field-level parameters
        % and sensible include defaults.  All accept the same optional
        % parameters as the corresponding standalone load_* functions.
        % ------------------------------------------------------------------

        function output = load_project(obj, varargin)
        % LOAD_PROJECT  Load project(s). Accepts 'name','id','tags', etc.
        %   Equivalent to brainstem.load_project(...) but uses this client's credentials.
            output = brainstem.load_project('settings', obj.settings_(), varargin{:});
        end

        function output = load_subject(obj, varargin)
        % LOAD_SUBJECT  Load subject(s). Accepts 'name','id','sex','strain', etc.
            output = brainstem.load_subject('settings', obj.settings_(), varargin{:});
        end

        function output = load_session(obj, varargin)
        % LOAD_SESSION  Load session(s). Accepts 'name','id','projects', etc.
            output = brainstem.load_session('settings', obj.settings_(), varargin{:});
        end

        function output = load_collection(obj, varargin)
        % LOAD_COLLECTION  Load collection(s). Accepts 'name','id','tags'.
            output = brainstem.load_collection('settings', obj.settings_(), varargin{:});
        end

        function output = load_cohort(obj, varargin)
        % LOAD_COHORT  Load cohort(s). Accepts 'name','id','tags'.
            output = brainstem.load_cohort('settings', obj.settings_(), varargin{:});
        end

        function output = load_behavior(obj, varargin)
        % LOAD_BEHAVIOR  Load behavior records. Accepts 'session','id','tags'.
            output = brainstem.load_behavior('settings', obj.settings_(), varargin{:});
        end

        function output = load_dataacquisition(obj, varargin)
        % LOAD_DATAACQUISITION  Load data acquisition records. Accepts 'session','id','tags'.
            output = brainstem.load_dataacquisition('settings', obj.settings_(), varargin{:});
        end

        function output = load_manipulation(obj, varargin)
        % LOAD_MANIPULATION  Load manipulation records. Accepts 'session','id','tags'.
            output = brainstem.load_manipulation('settings', obj.settings_(), varargin{:});
        end

        function output = load_procedure(obj, varargin)
        % LOAD_PROCEDURE  Load procedure records. Accepts 'subject','id','tags'.
            output = brainstem.load_procedure('settings', obj.settings_(), varargin{:});
        end

        function output = load_subjectlog(obj, varargin)
        % LOAD_SUBJECTLOG  Load subject log records. Accepts 'subject','type','description','id'.
            output = brainstem.load_subjectlog('settings', obj.settings_(), varargin{:});
        end

        function output = load_procedurelog(obj, varargin)
        % LOAD_PROCEDURELOG  Load procedure log records. Accepts 'subject','id','tags'.
            output = brainstem.load_procedurelog('settings', obj.settings_(), varargin{:});
        end

        function output = load_equipment(obj, varargin)
        % LOAD_EQUIPMENT  Load equipment records. Accepts 'name','session','id','tags'.
            output = brainstem.load_equipment('settings', obj.settings_(), varargin{:});
        end

        function output = load_consumablestock(obj, varargin)
        % LOAD_CONSUMABLESTOCK  Load consumable stock records. Accepts 'subject','id','tags'.
            output = brainstem.load_consumablestock('settings', obj.settings_(), varargin{:});
        end

        % ------------------------------------------------------------------
        function disp(obj)
        % DISP  Display a compact summary of the client state.
            authenticated = ~isempty(obj.token);
            fprintf('  BrainstemClient\n');
            fprintf('    url        : %s\n', obj.url);
            fprintf('    token_type : %s\n', obj.token_type);
            fprintf('    authenticated: %s\n', mat2str(authenticated));
            if authenticated
                n = min(8, numel(obj.token));
                fprintf('    token      : %s...\n', obj.token(1:n));
            end
        end
    end

    % ----------------------------------------------------------------------
    methods (Access = private)

        function s = settings_(obj)
        % Build the settings struct expected by the underlying functions.
            s.url   = obj.url;
            s.token = obj.token;
        end

        function token = load_or_request_token_(obj)
        % Load a cached PAT for this URL; warn when near expiry, re-auth if expired.
            auth_path = fullfile(prefdir, 'brainstem_authentication.mat');
            if exist(auth_path, 'file')
                credentials = load(auth_path, 'authentication');
                auth_tbl    = credentials.authentication;
                idx         = find(strcmp(obj.url, auth_tbl.urls));
                if ~isempty(idx)
                    has_expires = ismember('expires_at', auth_tbl.Properties.VariableNames);
                    has_saved   = ismember('saved_at',   auth_tbl.Properties.VariableNames);
                    if has_expires
                        days_left = auth_tbl.expires_at{idx} - now;
                    elseif has_saved
                        days_left = (auth_tbl.saved_at{idx} + 365) - now;
                    else
                        days_left = Inf;
                    end
                    if days_left <= 0
                        warning('BrainstemClient:tokenExpired', ...
                            'Saved token expired — re-authenticating.');
                        token = brainstem.get_token(obj.url);
                    elseif days_left < 15
                        warning('BrainstemClient:tokenNearExpiry', ...
                            'BrainSTEM token expires in ~%.0f days.', days_left);
                        token = auth_tbl.tokens{idx};
                    else
                        token = auth_tbl.tokens{idx};
                    end
                    return
                end
            end
            % No cached token — run the device authorization flow
            token = brainstem.get_token(obj.url);
        end

        function refresh_token_(obj)
        % Re-authenticate via the device authorization flow.
            warning('BrainstemClient:tokenExpired', ...
                'Token appears expired or invalid — re-authenticating.');
            obj.token = brainstem.get_token(obj.url);
        end

        function tf = is_auth_error_(~, ME)
        % Return true if the error message indicates a 401/403 response.
            tf = contains(ME.message, {'401','403','Unauthorized','Forbidden'}, ...
                          'IgnoreCase', true);
        end
    end
end
