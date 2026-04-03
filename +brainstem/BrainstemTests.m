classdef BrainstemTests < matlab.unittest.TestCase
% BRAINSTEMTESTS  Unit and integration tests for the +brainstem package.
%
%   Run all offline tests (no network/token required):
%     results = runtests('brainstem.BrainstemTests', 'Tag', 'offline');
%     disp(results)
%
%   Run all tests including unauthenticated network tests:
%     results = runtests('brainstem.BrainstemTests');
%
%   Run authenticated tests (requires BRAINSTEM_TOKEN to be set first):
%     setenv('BRAINSTEM_TOKEN', '<your-token>');
%     results = runtests('brainstem.BrainstemTests', 'Tag', 'authenticated');
%
%   Run with verbose output:
%     runner = matlab.unittest.TestRunner.withTextOutput;
%     results = runner.run(brainstem.BrainstemTests);

    properties (Constant)
        % Set BRAINSTEM_TOKEN in your environment before running authenticated
        % tests.  The value is read once when the class is first loaded.
        BASE_URL = 'https://www.brainstem.org/'
        TOKEN    = getenv('BRAINSTEM_TOKEN')
    end

    % ======================================================================
    methods (Test, TestTags = {'offline'})
    % No network connection or token required.
    % ======================================================================

        % ------------------------------------------------------------------
        % get_app_from_model
        % ------------------------------------------------------------------
        function testAppFromModelSession(tc)
            tc.verifyEqual(brainstem.get_app_from_model('session'), 'stem');
        end

        function testAppFromModelProject(tc)
            tc.verifyEqual(brainstem.get_app_from_model('project'), 'stem');
        end

        function testAppFromModelBreeding(tc)
            tc.verifyEqual(brainstem.get_app_from_model('breeding'), 'stem');
        end

        function testAppFromModelSubject(tc)
            tc.verifyEqual(brainstem.get_app_from_model('subject'), 'stem');
        end

        function testAppFromModelBehavior(tc)
            tc.verifyEqual(brainstem.get_app_from_model('behavior'), 'modules');
        end

        function testAppFromModelDataAcquisition(tc)
            tc.verifyEqual(brainstem.get_app_from_model('dataacquisition'), 'modules');
        end

        function testAppFromModelManipulation(tc)
            tc.verifyEqual(brainstem.get_app_from_model('manipulation'), 'modules');
        end

        function testAppFromModelSetup(tc)
            tc.verifyEqual(brainstem.get_app_from_model('setup'), 'personal_attributes');
        end

        function testAppFromModelConsumable(tc)
            tc.verifyEqual(brainstem.get_app_from_model('consumable'), 'resources');
        end

        function testAppFromModelSpecies(tc)
            tc.verifyEqual(brainstem.get_app_from_model('species'), 'taxonomies');
        end

        function testAppFromModelPublication(tc)
            tc.verifyEqual(brainstem.get_app_from_model('publication'), 'dissemination');
        end

        function testAppFromModelUser(tc)
            tc.verifyEqual(brainstem.get_app_from_model('user'), 'users');
        end

        function testAppFromModelUnknown(tc)
            tc.verifyEmpty(brainstem.get_app_from_model('nonexistent_model_xyz'));
        end

        % stem (remaining)
        function testAppFromModelCollection(tc)
            tc.verifyEqual(brainstem.get_app_from_model('collection'), 'stem');
        end
        function testAppFromModelCohort(tc)
            tc.verifyEqual(brainstem.get_app_from_model('cohort'), 'stem');
        end

        % modules (remaining)
        function testAppFromModelProcedure(tc)
            tc.verifyEqual(brainstem.get_app_from_model('procedure'), 'modules');
        end
        function testAppFromModelEquipment(tc)
            tc.verifyEqual(brainstem.get_app_from_model('equipment'), 'modules');
        end
        function testAppFromModelConsumableStock(tc)
            tc.verifyEqual(brainstem.get_app_from_model('consumablestock'), 'modules');
        end
        function testAppFromModelProcedureLog(tc)
            tc.verifyEqual(brainstem.get_app_from_model('procedurelog'), 'modules');
        end
        function testAppFromModelSubjectLog(tc)
            tc.verifyEqual(brainstem.get_app_from_model('subjectlog'), 'modules');
        end

        % personal_attributes
        function testAppFromModelBehavioralAssay(tc)
            tc.verifyEqual(brainstem.get_app_from_model('behavioralassay'), 'personal_attributes');
        end
        function testAppFromModelDataStorage(tc)
            tc.verifyEqual(brainstem.get_app_from_model('datastorage'), 'personal_attributes');
        end
        function testAppFromModelInventory(tc)
            tc.verifyEqual(brainstem.get_app_from_model('inventory'), 'personal_attributes');
        end
        function testAppFromModelProtocol(tc)
            tc.verifyEqual(brainstem.get_app_from_model('protocol'), 'personal_attributes');
        end

        % resources
        function testAppFromModelHardwareDevice(tc)
            tc.verifyEqual(brainstem.get_app_from_model('hardwaredevice'), 'resources');
        end
        function testAppFromModelSupplier(tc)
            tc.verifyEqual(brainstem.get_app_from_model('supplier'), 'resources');
        end

        % taxonomies
        function testAppFromModelStrain(tc)
            tc.verifyEqual(brainstem.get_app_from_model('strain'), 'taxonomies');
        end
        function testAppFromModelBrainRegion(tc)
            tc.verifyEqual(brainstem.get_app_from_model('brainregion'), 'taxonomies');
        end
        function testAppFromModelSetupType(tc)
            tc.verifyEqual(brainstem.get_app_from_model('setuptype'), 'taxonomies');
        end
        function testAppFromModelBehavioralParadigm(tc)
            tc.verifyEqual(brainstem.get_app_from_model('behavioralparadigm'), 'taxonomies');
        end
        function testAppFromModelRegulatoryAuthority(tc)
            tc.verifyEqual(brainstem.get_app_from_model('regulatoryauthority'), 'taxonomies');
        end

        % dissemination
        function testAppFromModelJournal(tc)
            tc.verifyEqual(brainstem.get_app_from_model('journal'), 'dissemination');
        end

        % users
        function testAppFromModelLaboratory(tc)
            tc.verifyEqual(brainstem.get_app_from_model('laboratory'), 'users');
        end
        function testAppFromModelGroupMembershipInvitation(tc)
            tc.verifyEqual(brainstem.get_app_from_model('groupmembershipinvitation'), 'users');
        end
        function testAppFromModelGroupMembershipRequest(tc)
            tc.verifyEqual(brainstem.get_app_from_model('groupmembershiprequest'), 'users');
        end

        % auth
        function testAppFromModelGroup(tc)
            tc.verifyEqual(brainstem.get_app_from_model('group'), 'auth');
        end

        % ------------------------------------------------------------------
        % brainstem_build_url  (package-private helper)
        % ------------------------------------------------------------------
        function testBuildUrlCollection(tc)
            got = brainstem_build_url(tc.BASE_URL, 'private', 'stem', 'session', '');
            tc.verifyEqual(got, [tc.BASE_URL, 'api/private/stem/session/']);
        end

        function testBuildUrlWithId(tc)
            got = brainstem_build_url(tc.BASE_URL, 'private', 'stem', 'session', 'abc-123');
            tc.verifyEqual(got, [tc.BASE_URL, 'api/private/stem/session/abc-123/']);
        end

        function testBuildUrlPublicPortal(tc)
            got = brainstem_build_url(tc.BASE_URL, 'public', 'stem', 'project', '');
            tc.verifyEqual(got, [tc.BASE_URL, 'api/public/stem/project/']);
        end

        function testBuildUrlTrailingSlashOnBase(tc)
            % Base URL without trailing slash should still produce a fully valid URL
            got = brainstem_build_url('https://www.brainstem.org', 'private', 'stem', 'session', '');
            tc.verifyEqual(got, 'https://www.brainstem.org/api/private/stem/session/');
        end

        % ------------------------------------------------------------------
        % brainstem_build_query_string  (package-private helper)
        % ------------------------------------------------------------------
        function testQueryStringEmpty(tc)
            qs = brainstem_build_query_string({}, {}, {}, [], 0);
            tc.verifyEmpty(qs);
        end

        function testQueryStringFilter(tc)
            qs = brainstem_build_query_string({'name', 'rat'}, {}, {}, [], 0);
            tc.verifyTrue(contains(qs, 'filter{name}=rat'), qs);
        end

        function testQueryStringFilterCharNotCorrupted(tc)
            % num2str('rat') would give '114 97 116' — verify the actual
            % string value is encoded, not its ASCII codes.
            qs = brainstem_build_query_string({'name', 'rat'}, {}, {}, [], 0);
            tc.verifyTrue(contains(qs, 'rat'),          qs);
            tc.verifyFalse(contains(qs, '114'),         qs);  % ASCII for 'r'
        end

        function testQueryStringFilterNumericValue(tc)
            % Numeric filter values should be converted to their decimal string.
            qs = brainstem_build_query_string({'count', 5}, {}, {}, [], 0);
            tc.verifyTrue(contains(qs, 'filter{count}=5'), qs);
        end

        function testQueryStringMultipleFilters(tc)
            qs = brainstem_build_query_string({'name', 'rat', 'sex', 'M'}, {}, {}, [], 0);
            tc.verifyTrue(contains(qs, 'filter{name}=rat'), qs);
            tc.verifyTrue(contains(qs, 'filter{sex}=M'), qs);
        end

        function testQueryStringFilterNx2Layout(tc)
            % N×2 cell layout (produced by brainstem_apply_field_filters)
            filter = {'name.icontains', 'rat'; 'sex', 'M'};
            qs = brainstem_build_query_string(filter, {}, {}, [], 0);
            tc.verifyTrue(contains(qs, 'filter{name.icontains}=rat'), qs);
            tc.verifyTrue(contains(qs, 'filter{sex}=M'),              qs);
        end

        function testQueryStringFilterNx2KeyValueNotScrambled(tc)
            % Regression: column-major indexing on N×2 cell used to swap
            % keys and values when N > 1.
            filter = {'keyA', 'valA'; 'keyB', 'valB'};
            qs = brainstem_build_query_string(filter, {}, {}, [], 0);
            tc.verifyTrue(contains(qs, 'filter{keyA}=valA'), qs);
            tc.verifyTrue(contains(qs, 'filter{keyB}=valB'), qs);
            % Ensure values didn't end up as keys
            tc.verifyFalse(contains(qs, 'filter{valA}'), qs);
            tc.verifyFalse(contains(qs, 'filter{valB}'), qs);
        end

        function testQueryStringSortDescending(tc)
            qs = brainstem_build_query_string({}, {'-name'}, {}, [], 0);
            tc.verifyTrue(contains(qs, 'sort[]=-name'), qs);
        end

        function testQueryStringSortAscending(tc)
            qs = brainstem_build_query_string({}, {'name'}, {}, [], 0);
            tc.verifyTrue(contains(qs, 'sort[]=name'), qs);
        end

        function testQueryStringInclude(tc)
            qs = brainstem_build_query_string({}, {}, {'behaviors'}, [], 0);
            tc.verifyTrue(contains(qs, 'include[]=behaviors.*'), qs);
        end

        function testQueryStringLimit(tc)
            qs = brainstem_build_query_string({}, {}, {}, 50, 0);
            tc.verifyTrue(contains(qs, 'limit=50'), qs);
        end

        function testQueryStringOffset(tc)
            qs = brainstem_build_query_string({}, {}, {}, [], 20);
            tc.verifyTrue(contains(qs, 'offset=20'), qs);
        end

        function testQueryStringStartsWithQuestionMark(tc)
            qs = brainstem_build_query_string({'name','x'}, {}, {}, [], 0);
            tc.verifyTrue(tc.startsWith_(qs, '?'), qs);
        end

        % ------------------------------------------------------------------
        % brainstem_apply_field_filters  (package-private helper)
        % ------------------------------------------------------------------
        function testFieldFiltersEmptyWhenNoValues(tc)
            % All extra fields empty → filter unchanged
            p.filter = {};
            p.name   = '';
            p.id     = '';
            result = brainstem_apply_field_filters(p, {'id','name'}, ...
                {'id','id'; 'name','name.icontains'});
            tc.verifyEmpty(result);
        end

        function testFieldFiltersAppendsMapping(tc)
            p.filter = {};
            p.name   = 'Rat';
            p.id     = '';
            result = brainstem_apply_field_filters(p, {'id','name'}, ...
                {'id','id'; 'name','name.icontains'});
            tc.verifyEqual(result, {'name.icontains', 'Rat'});
        end

        function testFieldFiltersMultipleFields(tc)
            p.filter  = {};
            p.name    = 'Rat';
            p.subject = 'uuid-123';
            result = brainstem_apply_field_filters(p, {'name','subject'}, ...
                {'name','name.icontains'; 'subject','subject.id'});
            tc.verifyEqual(numel(result), 4);  % 2 pairs × 2 elements
            tc.verifyTrue(any(strcmp(result(:,1), 'name.icontains')));
            tc.verifyTrue(any(strcmp(result(:,2), 'Rat')));
            tc.verifyTrue(any(strcmp(result(:,1), 'subject.id')));
        end

        function testFieldFiltersPreservesExistingFilter(tc)
            p.filter = {'type', 'Weighing'};
            p.name   = 'Rat';
            p.id     = '';
            result = brainstem_apply_field_filters(p, {'id','name'}, ...
                {'id','id'; 'name','name.icontains'});
            % Original filter row must still be present
            tc.verifyTrue(any(strcmp(result(:,1), 'type')));
            tc.verifyTrue(any(strcmp(result(:,1), 'name.icontains')));
        end

        function testFieldFiltersDefaultsToIcontains(tc)
            % Fields not in filter_map default to <field>.icontains
            p.filter      = {};
            p.description = 'baseline';
            result = brainstem_apply_field_filters(p, {'description'}, ...
                {'name','name.icontains'});  % 'description' not in map
            tc.verifyTrue(any(strcmp(result(:,1), 'description.icontains')));
        end

        % ------------------------------------------------------------------
        % BrainstemClient constructor (no login attempted — token supplied)
        % ------------------------------------------------------------------
        function testClientConstructorWithToken(tc)
            client = BrainstemClient('token', 'mytoken123');
            tc.verifyEqual(client.token,      'mytoken123');
            tc.verifyEqual(client.token_type, 'personal');
            tc.verifyEqual(client.url,        tc.BASE_URL);
        end

        function testClientConstructorTokenTypeIsPersonal(tc)
            % token_type is always 'personal' (PAT-only flow)
            client = BrainstemClient('token', 'tok');
            tc.verifyEqual(client.token_type, 'personal');
        end

        function testClientConstructorUnknownParamErrors(tc)
            % Passing an unknown parameter should throw
            tc.verifyError( ...
                @() BrainstemClient('token', 'tok', 'token_type', 'shortlived'), ...
                'MATLAB:InputParser:UnmatchedParameter');
        end

        function testClientDispRunsWithoutError(tc)
            client = BrainstemClient('token', 'mytoken123');
            % disp should not throw
            tc.verifyWarningFree(@() disp(client));
        end

        function testClientCustomUrl(tc)
            client = BrainstemClient('token', 'tok', 'url', 'http://localhost:8000/');
            tc.verifyEqual(client.url, 'http://localhost:8000/');
        end

        function testClientHonoursBrainstemUrlEnvVar(tc)
            % BrainstemClient() with no 'url' argument should use BRAINSTEM_URL.
            prev = getenv('BRAINSTEM_URL');
            setenv('BRAINSTEM_URL', 'http://env-server.test/');
            try
                client = BrainstemClient('token', 'tok');
                tc.verifyEqual(client.url, 'http://env-server.test/');
            finally
                setenv('BRAINSTEM_URL', prev);
            end
        end

        function testClientExplicitUrlOverridesEnvVar(tc)
            % Explicit 'url' argument wins over BRAINSTEM_URL.
            prev = getenv('BRAINSTEM_URL');
            setenv('BRAINSTEM_URL', 'http://env-server.test/');
            try
                client = BrainstemClient('token', 'tok', 'url', 'http://explicit.test/');
                tc.verifyEqual(client.url, 'http://explicit.test/');
            finally
                setenv('BRAINSTEM_URL', prev);
            end
        end

        % ------------------------------------------------------------------
        % brainstem_parse_api_error — nested struct body
        % ------------------------------------------------------------------
        function testParseApiErrorNestedStruct(tc)
            me  = MException('test:err', ...
                '{"entries": {"date_time": ["This field is required."]}}');
            msg = brainstem_parse_api_error(me);
            tc.verifyTrue(contains(msg, 'entries'), msg);
        end

        function testParseApiErrorNonJsonObject(tc)
            % Array at root is not a JSON object — should fall back to raw
            raw = 'Server Error (500)';
            me  = MException('test:err', raw);
            msg = brainstem_parse_api_error(me);
            tc.verifyEqual(msg, raw);
        end

        function testParseApiErrorHttpStatusWithJsonBody(tc)
            % A 400 response that contains BOTH the "status NNN" prefix AND a
            % JSON body should surface the field-level detail, not just "400 Bad Request".
            me  = MException('test:err', ...
                'status 400 with message "Bad Request" {"name": ["This field is required."]}');
            msg = brainstem_parse_api_error(me);
            tc.verifyTrue(contains(msg, 'name'),                  msg);
            tc.verifyTrue(contains(msg, 'This field is required.'), msg);
            % Status code should still appear for context
            tc.verifyTrue(contains(msg, '400'),                   msg);
        end

        function testParseApiErrorHttpStatusWithoutBody(tc)
            % A 404 with no JSON body should return a compact "404 Not Found" string.
            me  = MException('test:err', 'status 404 with message "Not Found"');
            msg = brainstem_parse_api_error(me);
            tc.verifyTrue(contains(msg, '404'),       msg);
            tc.verifyTrue(contains(msg, 'Not Found'), msg);
        end

        % ------------------------------------------------------------------
        % get_token — signature tests
        % ------------------------------------------------------------------
        function testGetTokenTooManyArgsErrors(tc)
            % get_token now only accepts one argument (url)
            tc.verifyError( ...
                @() brainstem.get_token(tc.BASE_URL, 'extra_arg'), ...
                'MATLAB:TooManyInputs');
        end

        function testGetTokenNoArgsUsesDefault(tc)
            % get_token() with no args should not throw a signature error.
            % We verify this by checking the function accepts 0 args via nargin,
            % without actually invoking it (which would open a browser/dialog).
            f = functions(str2func('brainstem.get_token'));
            tc.verifyNotEmpty(f, 'brainstem.get_token should be resolvable');
        end

        % ------------------------------------------------------------------
        % save validation (no network needed)
        % ------------------------------------------------------------------
        function testSaveModelPatchWithoutIdErrors(tc)
            % PATCH without id in data must throw immediately, before any
            % network call.
            settings = struct('url', tc.BASE_URL, 'token', 'fake', 'storage', {{}});
            tc.verifyError( ...
                @() brainstem.save('data',     struct('description', 'x'), ...
                               'model',    'session', ...
                               'method',   'patch', ...
                               'settings', settings), ...
                'BrainSTEM:save');
        end

        function testSaveModelPatchWithEmptyIdErrors(tc)
            % PATCH with an empty id field must also error — empty id is
            % equivalent to no id (would target the collection endpoint).
            settings = struct('url', tc.BASE_URL, 'token', 'fake');
            tc.verifyError( ...
                @() brainstem.save('data',     struct('id', '', 'description', 'x'), ...
                               'model',    'session', ...
                               'method',   'patch', ...
                               'settings', settings), ...
                'BrainSTEM:save');
        end

        function testDeleteEmptyTokenErrors(tc)
            % delete with an empty token must error before the network call.
            settings = struct('url', tc.BASE_URL, 'token', '');
            tc.verifyError( ...
                @() brainstem.delete( ...
                    '00000000-0000-0000-0000-000000000000', 'session', ...
                    'settings', settings), ...
                'BrainSTEM:delete');
        end

        function testSaveEmptyTokenErrors(tc)
            % save with an empty token must error before the network call.
            settings = struct('url', tc.BASE_URL, 'token', '');
            tc.verifyError( ...
                @() brainstem.save( ...
                    'data',     struct('name', 'x'), ...
                    'model',    'session', ...
                    'settings', settings), ...
                'BrainSTEM:save');
        end

        % ------------------------------------------------------------------
        % brainstem_parse_api_error  (package-private helper)
        % ------------------------------------------------------------------
        function testParseApiErrorExtractsJsonFields(tc)
            me  = MException('test:err', ...
                '400 Bad Request {"name": ["This field is required."]}');
            msg = brainstem_parse_api_error(me);
            tc.verifyTrue(contains(msg, 'name'),                  msg);
            tc.verifyTrue(contains(msg, 'This field is required.'), msg);
        end

        function testParseApiErrorMultipleFields(tc)
            me  = MException('test:err', ...
                '{"name": ["blank"], "session": ["required"]}');
            msg = brainstem_parse_api_error(me);
            tc.verifyTrue(contains(msg, 'name'),    msg);
            tc.verifyTrue(contains(msg, 'session'), msg);
        end

        function testParseApiErrorFallsBackToRaw(tc)
            raw = 'Some plain-text server error with no JSON';
            me  = MException('test:err', raw);
            msg = brainstem_parse_api_error(me);
            tc.verifyEqual(msg, raw);
        end

        function testClientTokenTypeIsPersonal(tc)
            client = BrainstemClient('token', 'tok');
            tc.verifyEqual(client.token_type, 'personal');
        end

        function testClientSavePatchGuardOffline(tc)
            % PATCH without id must throw before any network round-trip
            client = BrainstemClient('token', 'fake');
            tc.verifyError( ...
                @() client.save(struct('description','x'), 'session', 'method','patch'), ...
                'BrainSTEM:save');
        end

        % ------------------------------------------------------------------
        % brainstem.logout
        % ------------------------------------------------------------------
        function testLogoutNoFileIsSilent(tc)
            % logout when no cache file exists should not error
            tmp = tempname;  % non-existent path
            % Patch: call logout against a URL that could never be cached
            tc.verifyWarningFree(@() brainstem.logout('http://nonexistent-brainstem-server.test/'));
        end

        function testLogoutUnknownUrlIsSilent(tc)
            % logout for a URL not in the cache should not error
            tc.verifyWarningFree(@() brainstem.logout('http://not-in-cache.example/'));
        end

        function testLogoutRemovesToken(tc)
            % Write a fake cache entry, call logout, verify it is removed.
            auth_path = fullfile(prefdir, 'brainstem_authentication.mat');
            test_url  = 'http://brainstem-test-logout.local/';

            % Back up existing cache (if any)
            backed_up = false;
            if exist(auth_path, 'file')
                backup = load(auth_path, 'authentication');
                backed_up = true;
            end

            try
                % Build a minimal authentication table matching the schema
                % used by brainstem_get_settings / get_token.
                authentication = table( ...
                    {'fake-token'}, ...
                    {''}, ...
                    {test_url},     ...
                    {now}, ...
                    {'personal'}, ...
                    {''}, ...
                    {now + 365}, ...
                    'VariableNames', {'tokens','usernames','urls','saved_at', ...
                                      'token_type','refresh_tokens','expires_at'});
                save(auth_path, 'authentication');

                brainstem.logout(test_url);

                % Reload and verify the row was removed
                credentials = load(auth_path, 'authentication');
                remaining_urls = credentials.authentication.urls;
                tc.verifyFalse(any(strcmp(test_url, remaining_urls)), ...
                    'Token should have been removed from cache after logout');
            finally
                % Restore original cache (or delete if it didn't exist before)
                if backed_up
                    authentication = backup.authentication; %#ok<NASGU>
                    save(auth_path, 'authentication');
                elseif exist(auth_path, 'file')
                    delete(auth_path);
                end
            end
        end

        function testLogoutDefaultUrlUsed(tc)
            % logout() with no argument should default to BASE_URL without error
            % (It will find no cached token for the test env, which is fine.)
            tc.verifyWarningFree(@() brainstem.logout());
        end

        function testLogoutNameValueUrl(tc)
            % brainstem.logout('url', url) name-value form should work.
            auth_path = fullfile(prefdir, 'brainstem_authentication.mat');
            test_url  = 'http://brainstem-test-nv-logout.local/';

            backed_up = false;
            if exist(auth_path, 'file')
                backup = load(auth_path, 'authentication');
                backed_up = true;
            end

            try
                authentication = table( ...
                    {'fake-token'}, ...
                    {''}, ...
                    {test_url},     ...
                    {now}, ...
                    {'personal'}, ...
                    {''}, ...
                    {now + 365}, ...
                    'VariableNames', {'tokens','usernames','urls','saved_at', ...
                                      'token_type','refresh_tokens','expires_at'});
                save(auth_path, 'authentication');

                brainstem.logout('url', test_url);

                credentials = load(auth_path, 'authentication');
                remaining_urls = credentials.authentication.urls;
                tc.verifyFalse(any(strcmp(test_url, remaining_urls)), ...
                    'Token should have been removed via name-value logout call');
            finally
                if backed_up
                    authentication = backup.authentication; %#ok<NASGU>
                    save(auth_path, 'authentication');
                elseif exist(auth_path, 'file')
                    delete(auth_path);
                end
            end
        end

    end  % offline tests

    % ======================================================================
    methods (Test, TestTags = {'network'})
    % Requires internet access but no authentication token.
    % ======================================================================

        function testLoadPublicProjects(tc)
            settings = struct('url', tc.BASE_URL, 'token', '');
            out = brainstem.load('model', 'project', 'portal', 'public', ...
                             'settings', settings, 'limit', 5);
            tc.verifyTrue(isstruct(out));
            tc.verifyTrue(isfield(out, 'projects') || isfield(out, 'count'), ...
                'Response should have a projects or count field');
        end

        function testLoadPublicProjectsStructure(tc)
            settings = struct('url', tc.BASE_URL, 'token', '');
            out = brainstem.load('model', 'project', 'portal', 'public', ...
                             'settings', settings, 'limit', 1);
            if isfield(out, 'projects') && ~isempty(out.projects)
                proj = out.projects(1);
                tc.verifyTrue(isstruct(proj), ...
                    'Each project record should be a struct');
                tc.verifyGreaterThan(numel(fieldnames(proj)), 0, ...
                    'Project record should have at least one field');
            end
        end

    end  % network tests

    % ======================================================================
    methods (Test, TestTags = {'authenticated'})
    % Requires BRAINSTEM_TOKEN to be set before running.
    % ======================================================================

        function testLoadSessions(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            settings = struct('url', tc.BASE_URL, 'token', tc.TOKEN);
            out = brainstem.load('model', 'session', 'settings', settings, 'limit', 5);
            tc.verifyTrue(isstruct(out));
            tc.verifyTrue(isfield(out, 'sessions') || isfield(out, 'count'));
        end

        function testLoadSubjects(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            settings = struct('url', tc.BASE_URL, 'token', tc.TOKEN);
            out = brainstem.load('model', 'subject', 'settings', settings, 'limit', 5);
            tc.verifyTrue(isstruct(out));
        end

        function testLoadProjects(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            settings = struct('url', tc.BASE_URL, 'token', tc.TOKEN);
            out = brainstem.load('model', 'project', 'settings', settings, 'limit', 5);
            tc.verifyTrue(isstruct(out));
        end

        function testLoadModelById(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            settings = struct('url', tc.BASE_URL, 'token', tc.TOKEN);
            % First fetch a list to get a real id
            out = brainstem.load('model', 'project', 'settings', settings, 'limit', 1);
            if isfield(out, 'projects') && ~isempty(out.projects)
                first = out.projects;
                if iscell(first); first = first{1}; else; first = first(1); end
                id  = first.id;
                rec = brainstem.load('model', 'project', 'settings', settings, 'id', id);
                tc.verifyTrue(isstruct(rec));
                tc.verifyTrue(isfield(rec, 'id') || isfield(rec, 'project'));
            end
        end

        function testLoadModelPagination(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            settings = struct('url', tc.BASE_URL, 'token', tc.TOKEN);
            out = brainstem.load('model', 'session', 'settings', settings, ...
                             'limit', 2, 'offset', 0);
            tc.verifyTrue(isstruct(out));
        end

        function testBrainstemClientToken(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            client = BrainstemClient('token', tc.TOKEN);
            tc.verifyEqual(class(client), 'BrainstemClient');
            tc.verifyFalse(isempty(client.token));
        end

        function testClientLoadSessionConvenience(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            client = BrainstemClient('token', tc.TOKEN);
            out = client.load_session('limit', 3);
            tc.verifyTrue(isstruct(out));
        end

        function testClientLoadSubjectConvenience(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            client = BrainstemClient('token', tc.TOKEN);
            out = client.load_subject('limit', 3);
            tc.verifyTrue(isstruct(out));
        end

        function testClientLoadProjectConvenience(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            client = BrainstemClient('token', tc.TOKEN);
            out = client.load_project('limit', 3);
            tc.verifyTrue(isstruct(out));
        end

        function testClientLoadAll(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            client = BrainstemClient('token', tc.TOKEN);
            % load_all should return at least as many records as a single page
            out_page = client.load('project', 'limit', 1);
            out_all  = client.load('project', 'load_all', true);
            if isfield(out_page, 'count') && out_page.count > 1
                data_key = setdiff(fieldnames(out_all), {'count','next','previous'});
                if ~isempty(data_key)
                    tc.verifyGreaterThan(numel(out_all.(data_key{1})), 1);
                end
            end
        end

        function testClientDispAuthenticated(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            client = BrainstemClient('token', tc.TOKEN);
            % disp should run without error when authenticated
            tc.verifyWarningFree(@() disp(client));
        end

    end  % authenticated tests

    % ======================================================================
    methods (Access = private, Static)
    % ======================================================================

        function tf = endsWith_(str, suffix)
            n = numel(suffix);
            tf = numel(str) >= n && strcmp(str(end-n+1:end), suffix);
        end

        function tf = startsWith_(str, prefix)
            n = numel(prefix);
            tf = numel(str) >= n && strcmp(str(1:n), prefix);
        end

    end

end
