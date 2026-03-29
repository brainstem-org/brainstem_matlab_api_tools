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
            tc.verifyEqual(get_app_from_model('session'), 'stem');
        end

        function testAppFromModelProject(tc)
            tc.verifyEqual(get_app_from_model('project'), 'stem');
        end

        function testAppFromModelBreeding(tc)
            tc.verifyEqual(get_app_from_model('breeding'), 'stem');
        end

        function testAppFromModelSubject(tc)
            tc.verifyEqual(get_app_from_model('subject'), 'stem');
        end

        function testAppFromModelBehavior(tc)
            tc.verifyEqual(get_app_from_model('behavior'), 'modules');
        end

        function testAppFromModelDataAcquisition(tc)
            tc.verifyEqual(get_app_from_model('dataacquisition'), 'modules');
        end

        function testAppFromModelManipulation(tc)
            tc.verifyEqual(get_app_from_model('manipulation'), 'modules');
        end

        function testAppFromModelSetup(tc)
            tc.verifyEqual(get_app_from_model('setup'), 'personal_attributes');
        end

        function testAppFromModelConsumable(tc)
            tc.verifyEqual(get_app_from_model('consumable'), 'resources');
        end

        function testAppFromModelSpecies(tc)
            tc.verifyEqual(get_app_from_model('species'), 'taxonomies');
        end

        function testAppFromModelPublication(tc)
            tc.verifyEqual(get_app_from_model('publication'), 'dissemination');
        end

        function testAppFromModelUser(tc)
            tc.verifyEqual(get_app_from_model('user'), 'users');
        end

        function testAppFromModelUnknown(tc)
            tc.verifyEmpty(get_app_from_model('nonexistent_model_xyz'));
        end

        % stem (remaining)
        function testAppFromModelCollection(tc)
            tc.verifyEqual(get_app_from_model('collection'), 'stem');
        end
        function testAppFromModelCohort(tc)
            tc.verifyEqual(get_app_from_model('cohort'), 'stem');
        end

        % modules (remaining)
        function testAppFromModelProcedure(tc)
            tc.verifyEqual(get_app_from_model('procedure'), 'modules');
        end
        function testAppFromModelEquipment(tc)
            tc.verifyEqual(get_app_from_model('equipment'), 'modules');
        end
        function testAppFromModelConsumableStock(tc)
            tc.verifyEqual(get_app_from_model('consumablestock'), 'modules');
        end
        function testAppFromModelProcedureLog(tc)
            tc.verifyEqual(get_app_from_model('procedurelog'), 'modules');
        end
        function testAppFromModelSubjectLog(tc)
            tc.verifyEqual(get_app_from_model('subjectlog'), 'modules');
        end

        % personal_attributes
        function testAppFromModelBehavioralAssay(tc)
            tc.verifyEqual(get_app_from_model('behavioralassay'), 'personal_attributes');
        end
        function testAppFromModelDataStorage(tc)
            tc.verifyEqual(get_app_from_model('datastorage'), 'personal_attributes');
        end
        function testAppFromModelInventory(tc)
            tc.verifyEqual(get_app_from_model('inventory'), 'personal_attributes');
        end
        function testAppFromModelProtocol(tc)
            tc.verifyEqual(get_app_from_model('protocol'), 'personal_attributes');
        end

        % resources
        function testAppFromModelHardwareDevice(tc)
            tc.verifyEqual(get_app_from_model('hardwaredevice'), 'resources');
        end
        function testAppFromModelSupplier(tc)
            tc.verifyEqual(get_app_from_model('supplier'), 'resources');
        end

        % taxonomies
        function testAppFromModelStrain(tc)
            tc.verifyEqual(get_app_from_model('strain'), 'taxonomies');
        end
        function testAppFromModelBrainRegion(tc)
            tc.verifyEqual(get_app_from_model('brainregion'), 'taxonomies');
        end
        function testAppFromModelSetupType(tc)
            tc.verifyEqual(get_app_from_model('setuptype'), 'taxonomies');
        end
        function testAppFromModelBehavioralParadigm(tc)
            tc.verifyEqual(get_app_from_model('behavioralparadigm'), 'taxonomies');
        end
        function testAppFromModelRegulatoryAuthority(tc)
            tc.verifyEqual(get_app_from_model('regulatoryauthority'), 'taxonomies');
        end

        % dissemination
        function testAppFromModelJournal(tc)
            tc.verifyEqual(get_app_from_model('journal'), 'dissemination');
        end

        % users
        function testAppFromModelLaboratory(tc)
            tc.verifyEqual(get_app_from_model('laboratory'), 'users');
        end
        function testAppFromModelGroupMembershipInvitation(tc)
            tc.verifyEqual(get_app_from_model('groupmembershipinvitation'), 'users');
        end
        function testAppFromModelGroupMembershipRequest(tc)
            tc.verifyEqual(get_app_from_model('groupmembershiprequest'), 'users');
        end

        % auth
        function testAppFromModelGroup(tc)
            tc.verifyEqual(get_app_from_model('group'), 'auth');
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
            % Base URL without trailing slash should still produce valid URL
            got = brainstem_build_url('https://www.brainstem.org', 'private', 'stem', 'session', '');
            tc.verifyTrue(endsWith_(got, 'session/'));
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

        function testQueryStringMultipleFilters(tc)
            qs = brainstem_build_query_string({'name', 'rat', 'sex', 'M'}, {}, {}, [], 0);
            tc.verifyTrue(contains(qs, 'filter{name}=rat'), qs);
            tc.verifyTrue(contains(qs, 'filter{sex}=M'), qs);
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
            tc.verifyTrue(startsWith_(qs, '?'), qs);
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
            % Fields not in filter_map get <field>.icontains key
            p.filter      = {};
            p.description = 'baseline';
            result = brainstem_apply_field_filters(p, {'description'}, ...
                containers.Map.empty);  % empty map forces default
            % Can't easily pass empty Map — test via a filter_map that
            % does not include 'description':
            result2 = brainstem_apply_field_filters(p, {'description'}, ...
                {'name','name.icontains'});
            tc.verifyTrue(any(strcmp(result2(:,1), 'description.icontains')));
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

        function testClientConstructorTokenTypeShortlived(tc)
            client = BrainstemClient('token', 'tok', 'token_type', 'shortlived');
            tc.verifyEqual(client.token_type, 'shortlived');
        end

        function testClientConstructorTokenTypeCaseInsensitive(tc)
            % 'Shortlived' and 'PERSONAL' both accepted
            c1 = BrainstemClient('token', 'tok', 'token_type', 'Shortlived');
            tc.verifyEqual(c1.token_type, 'shortlived');
            c2 = BrainstemClient('token', 'tok', 'token_type', 'PERSONAL');
            tc.verifyEqual(c2.token_type, 'personal');
        end

        function testClientConstructorInvalidTokenTypeErrors(tc)
            tc.verifyError( ...
                @() BrainstemClient('token', 'tok', 'token_type', 'badtype'), ...
                'MATLAB:InputParser:ArgumentFailedValidation');
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

        % ------------------------------------------------------------------
        % get_token — input validation (no network call made)
        % ------------------------------------------------------------------
        function testGetTokenRejectsInvalidType(tc)
            % Should throw before any network call since token_type is invalid
            tc.verifyError( ...
                @() get_token(tc.BASE_URL, 'u@u.com', 'pass', 'badtype'), ...
                'BrainSTEM:getToken');
        end

        function testGetTokenAcceptsPersonal(tc)
            % Valid token_type='personal' passes validation
            % (will fail at network — that's expected, we just test the guard)
            try
                get_token(tc.BASE_URL, 'bad@user.com', 'wrongpass', 'personal');
            catch ME
                tc.verifyNotEqual(ME.identifier, 'BrainSTEM:getToken', ...
                    'Should not throw a getToken validation error for ''personal''');
            end
        end

        function testGetTokenAcceptsShortlived(tc)
            % Valid token_type='shortlived' passes validation
            try
                get_token(tc.BASE_URL, 'bad@user.com', 'wrongpass', 'shortlived');
            catch ME
                tc.verifyNotEqual(ME.identifier, 'BrainSTEM:getToken', ...
                    'Should not throw a getToken validation error for ''shortlived''');
            end
        end

        % ------------------------------------------------------------------
        % save_model validation (no network needed)
        % ------------------------------------------------------------------
        function testSaveModelPatchWithoutIdErrors(tc)
            % PATCH without id in data must throw immediately, before any
            % network call.
            settings = struct('url', tc.BASE_URL, 'token', 'fake', 'storage', {{}});
            tc.verifyError( ...
                @() save_model('data',     struct('description', 'x'), ...
                               'model',    'session', ...
                               'method',   'patch', ...
                               'settings', settings), ...
                'BrainSTEM:saveModel');
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

    end  % offline tests

    % ======================================================================
    methods (Test, TestTags = {'network'})
    % Requires internet access but no authentication token.
    % ======================================================================

        function testLoadPublicProjects(tc)
            settings = struct('url', tc.BASE_URL, 'token', '', 'storage', {{}});
            out = load_model('model', 'project', 'portal', 'public', ...
                             'settings', settings, 'limit', 5);
            tc.verifyTrue(isstruct(out));
            tc.verifyTrue(isfield(out, 'projects') || isfield(out, 'count'), ...
                'Response should have a projects or count field');
        end

        function testLoadPublicProjectsStructure(tc)
            settings = struct('url', tc.BASE_URL, 'token', '', 'storage', {{}});
            out = load_model('model', 'project', 'portal', 'public', ...
                             'settings', settings, 'limit', 1);
            if isfield(out, 'projects') && ~isempty(out.projects)
                tc.verifyTrue(isfield(out.projects(1), 'id'), ...
                    'Project record should have an id field');
                tc.verifyTrue(isfield(out.projects(1), 'name'), ...
                    'Project record should have a name field');
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
            settings = struct('url', tc.BASE_URL, 'token', tc.TOKEN, 'storage', {{}});
            out = load_model('model', 'session', 'settings', settings, 'limit', 5);
            tc.verifyTrue(isstruct(out));
            tc.verifyTrue(isfield(out, 'sessions') || isfield(out, 'count'));
        end

        function testLoadSubjects(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            settings = struct('url', tc.BASE_URL, 'token', tc.TOKEN, 'storage', {{}});
            out = load_model('model', 'subject', 'settings', settings, 'limit', 5);
            tc.verifyTrue(isstruct(out));
        end

        function testLoadProjects(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            settings = struct('url', tc.BASE_URL, 'token', tc.TOKEN, 'storage', {{}});
            out = load_model('model', 'project', 'settings', settings, 'limit', 5);
            tc.verifyTrue(isstruct(out));
        end

        function testLoadModelById(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            settings = struct('url', tc.BASE_URL, 'token', tc.TOKEN, 'storage', {{}});
            % First fetch a list to get a real id
            out = load_model('model', 'project', 'settings', settings, 'limit', 1);
            if isfield(out, 'projects') && ~isempty(out.projects)
                id  = out.projects(1).id;
                rec = load_model('model', 'project', 'settings', settings, 'id', id);
                tc.verifyTrue(isstruct(rec));
                tc.verifyTrue(isfield(rec, 'id') || isfield(rec, 'project'));
            end
        end

        function testLoadModelPagination(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            settings = struct('url', tc.BASE_URL, 'token', tc.TOKEN, 'storage', {{}});
            out = load_model('model', 'session', 'settings', settings, ...
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
            out_page = client.load_model('project', 'limit', 1);
            out_all  = client.load_model('project', 'load_all', true);
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

        function testClientTokenTypeProperty(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            client = BrainstemClient('token', tc.TOKEN);
            tc.verifyEqual(client.token_type, 'personal');
        end

        function testClientSaveModelPatchGuard(tc)
            tc.assumeNotEmpty(tc.TOKEN, ...
                'Set BRAINSTEM_TOKEN env variable to run authenticated tests');
            client = BrainstemClient('token', tc.TOKEN);
            % PATCH without id must throw before any network round-trip
            tc.verifyError( ...
                @() client.save_model(struct('description','x'), 'session', 'method','patch'), ...
                'BrainSTEM:saveModel');
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
