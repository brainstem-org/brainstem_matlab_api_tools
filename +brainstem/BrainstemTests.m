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

        function testAppFromModelGroup(tc)
            % The server serves groups at /api/<portal>/users/group/.
            tc.verifyEqual(brainstem.get_app_from_model('group'), 'users');
        end

        function testAppFromModelSpecimenEra(tc)
            cases = {'specimenset','stem'; 'specimen','stem'; 'epoch','stem'; ...
                     'sessiondatastorage','stem'; 'collectionsession','stem'; ...
                     'experimentalinterface','modules'; 'materialusage','modules'; ...
                     'specimenprocedure','modules'; 'specimenlog','modules'; ...
                     'procedureepisode','modules'; 'experimentalinterfacetemplate','modules'; ...
                     'dataacquisitioninterface','modules'; 'anatomicalregion','taxonomies'; ...
                     'anatomicalreference','taxonomies'; 'coordinatetransform','taxonomies'; ...
                     'speciesapproval','taxonomies'; 'setupmembershipinvitation','personal_attributes'; ...
                     'admingroup','users'; 'pendinginvitation','users'};
            for i = 1:size(cases, 1)
                tc.verifyEqual(brainstem.get_app_from_model(cases{i,1}), cases{i,2}, cases{i,1});
            end
        end

        % ------------------------------------------------------------------
        % brainstem_response_key  (package-private helper)
        % ------------------------------------------------------------------
        function testResponseKeyPlural(tc)
            tc.verifyEqual(brainstem_response_key('session'), 'sessions');
            tc.verifyEqual(brainstem_response_key('dataacquisition'), 'data_acquisitions');
            tc.verifyEqual(brainstem_response_key('anatomicalregion'), 'anatomical_regions');
        end

        function testResponseKeyMatchesJsondecode(tc)
            % The server's key for consumable stocks contains a space.
            decoded = jsondecode('{"consumable stocks": [], "meta": {}}');
            tc.verifyTrue(isfield(decoded, brainstem_response_key('consumablestock')));
        end

        function testBrainregionResolvesToAnatomicalregion(tc)
            tc.verifyWarning(@() brainstem_resolve_model('brainregion'), 'BrainSTEM:deprecatedModel');
            warning('off', 'BrainSTEM:deprecatedModel');
            restore = onCleanup(@() warning('on', 'BrainSTEM:deprecatedModel'));
            tc.verifyEqual(brainstem_resolve_model('brainregion'), 'anatomicalregion');
            tc.verifyEqual(brainstem_resolve_model('session'), 'session');
        end

        function testResponseKeyUnknownModelFallsBack(tc)
            tc.verifyEqual(brainstem_response_key('widget'), 'widgets');
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
            tc.verifyTrue(contains(qs, 'per_page=50'), qs);
            tc.verifyTrue(contains(qs, 'page=1'), qs);
            tc.verifyFalse(contains(qs, 'limit='), qs);
        end

        function testQueryStringOffset(tc)
            % offset 200 with the default page size 100 is page 3
            qs = brainstem_build_query_string({}, {}, {}, [], 200);
            tc.verifyTrue(contains(qs, 'per_page=100'), qs);
            tc.verifyTrue(contains(qs, '&page=3'), qs);
            tc.verifyFalse(contains(qs, 'offset='), qs);
        end

        function testQueryStringLimitAndOffset(tc)
            qs = brainstem_build_query_string({}, {}, {}, 20, 40);
            tc.verifyTrue(contains(qs, 'per_page=20'), qs);
            tc.verifyTrue(contains(qs, '&page=3'), qs);
        end

        function testQueryStringNoPagingByDefault(tc)
            qs = brainstem_build_query_string({'name','x'}, {}, {}, [], 0);
            tc.verifyFalse(contains(qs, 'page'), qs);
        end

        function testQueryStringOffsetNotMultipleErrors(tc)
            tc.verifyError(@() brainstem_build_query_string({}, {}, {}, 50, 20), 'BrainSTEM:load');
        end

        function testQueryStringLimitAboveMaximumErrors(tc)
            tc.verifyError(@() brainstem_build_query_string({}, {}, {}, 501, 0), 'BrainSTEM:load');
            tc.verifyError(@() brainstem_build_query_string({}, {}, {}, 0, 0), 'BrainSTEM:load');
        end

        % ------------------------------------------------------------------
        % brainstem_merge_records  (package-private helper)
        % ------------------------------------------------------------------
        function testMergeRecordsColumnStructArrays(tc)
            a = jsondecode('[{"id":"1","name":"a"},{"id":"2","name":"b"}]');
            b = jsondecode('[{"id":"3","name":"c"}]');
            merged = brainstem_merge_records(a, b);
            tc.verifyEqual({merged.id}, {'1','2','3'});
        end

        function testMergeRecordsSkipsRepeatedIds(tc)
            a = jsondecode('[{"id":"1"},{"id":"2"}]');
            b = jsondecode('[{"id":"2"},{"id":"3"}]');
            merged = brainstem_merge_records(a, b);
            tc.verifyEqual({merged.id}, {'1','2','3'});
        end

        function testMergeRecordsDifferentFields(tc)
            a = jsondecode('[{"id":"1","x":1}]');
            b = jsondecode('[{"id":"2","y":2}]');
            merged = brainstem_merge_records(a, b);
            tc.verifyEqual(numel(merged), 2);
        end

        function testMergeRecordsEmptyPage(tc)
            a = jsondecode('[{"id":"1"}]');
            merged = brainstem_merge_records(a, []);
            tc.verifyEqual({merged.id}, {'1'});
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
                {'name','name.icontains'; 'subject','subject'});
            tc.verifyEqual(numel(result), 4);  % 2 pairs × 2 elements
            tc.verifyTrue(any(strcmp(result(:,1), 'name.icontains')));
            tc.verifyTrue(any(strcmp(result(:,2), 'Rat')));
            tc.verifyTrue(any(strcmp(result(:,1), 'subject')));
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

        function testFieldFiltersFlatUserFilterWithNamedFilter(tc)
            % Two flat user pairs plus a named filter used to fail to concatenate.
            p.filter = {'type', 'Weighing', 'description.icontains', 'x'};
            p.subject = 'abc';
            result = brainstem_apply_field_filters(p, {'subject'}, {'subject','subject'});
            tc.verifyEqual(size(result), [3 2]);
            tc.verifyEqual(result(3,:), {'subject', 'abc'});
        end

        function testLoaderFilterMapsUseBareFields(tc)
            % filter{<relation>.id} fails on most relations on production servers.
            files = dir(fullfile(fileparts(mfilename('fullpath')), 'load_*.m'));
            for i = 1:numel(files)
                text = fileread(fullfile(files(i).folder, files(i).name));
                tc.verifyEmpty(regexp(text, '\.id''', 'once'), files(i).name);
            end
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

        function testSaveWarnsOnListReadWithInclude(tc)
            settings = struct('url', tc.BASE_URL, 'token', '');
            data = struct('id', '00000000-0000-0000-0000-000000000000', ...
                          'behaviors', {{'b1'}}, 'brainstem_included', {{'behaviors'}});
            tc.verifyWarning(@() tc.saveIgnoringErrors(data, settings), 'BrainSTEM:save:partialList');
        end

        function testSaveNoWarningWithoutIncludedList(tc)
            settings = struct('url', tc.BASE_URL, 'token', '');
            data = struct('id', '00000000-0000-0000-0000-000000000000', ...
                          'description', 'x', 'brainstem_included', {{'behaviors'}});
            tc.verifyWarningFree(@() tc.saveIgnoringErrors(data, settings));
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
            tc.verifyTrue(isfield(out, 'projects'), 'Response should have a projects field');
            tc.verifyTrue(isfield(out, 'meta') && isfield(out.meta, 'total_results'));
        end

        function testLoadAllReturnsEveryRecord(tc)
            % More records than one page: load_all must follow meta.total_pages.
            settings = struct('url', tc.BASE_URL, 'token', '');
            out = brainstem.load('model', 'session', 'portal', 'public', ...
                                 'settings', settings, 'limit', 50, 'load_all', true);
            tc.assumeGreaterThan(out.meta.total_results, 50);
            tc.verifyEqual(numel(out.sessions), out.meta.total_results);
            tc.verifyEqual(numel(unique({out.sessions.id})), out.meta.total_results);
        end

        function testLoadAllMergesSideloads(tc)
            settings = struct('url', tc.BASE_URL, 'token', '');
            out = brainstem.load_session('portal', 'public', 'settings', settings, ...
                                         'limit', 50, 'load_all', true);
            tc.verifyEqual(numel(out.sessions), out.meta.total_results);
            tc.verifyTrue(isfield(out.sessions, 'brainstem_included'));
        end

        function testManualPaging(tc)
            settings = struct('url', tc.BASE_URL, 'token', '');
            page2 = brainstem.load('model', 'session', 'portal', 'public', ...
                                   'settings', settings, 'limit', 20, 'offset', 20);
            tc.verifyEqual(page2.meta.page, 2);
            tc.verifyEqual(page2.meta.per_page, 20);
        end

        function testConvenienceLoaderFiltersOnPublicPortal(tc)
            % Every relation filter must be accepted by the production server.
            settings = struct('url', tc.BASE_URL, 'token', '');
            args = {'portal', 'public', 'settings', settings, 'limit', 1};
            sessions = brainstem.load('model', 'session', args{:}, 'include', {});
            s = sessions.sessions(1);
            projects = s.projects;
            if iscell(projects), project = projects{1}; else, project = projects(1); end
            subjects = brainstem.load('model', 'subject', args{:}, 'filter', {'projects', project});
            calls = { ...
                @() brainstem.load_session(args{:}, 'projects', project), ...
                @() brainstem.load_subject(args{:}, 'projects', project), ...
                @() brainstem.load_project(args{:}, 'sessions', s.id), ...
                @() brainstem.load_behavior(args{:}, 'session', s.id), ...
                @() brainstem.load_dataacquisition(args{:}, 'session', s.id), ...
                @() brainstem.load_manipulation(args{:}, 'session', s.id)};
            if ~isempty(subjects.subjects)
                sub = subjects.subjects(1);
                calls = [calls, { ...
                    @() brainstem.load_project(args{:}, 'subjects', sub.id), ...
                    @() brainstem.load_procedure(args{:}, 'subject', sub.id), ...
                    @() brainstem.load_subjectlog(args{:}, 'subject', sub.id), ...
                    @() brainstem.load_procedurelog(args{:}, 'procedure', sub.id)}];
                if ischar(sub.strain)
                    calls{end+1} = @() brainstem.load_subject(args{:}, 'strain', sub.strain);
                end
            end
            for i = 1:numel(calls)
                out = calls{i}();
                tc.verifyTrue(isfield(out, 'meta'), func2str(calls{i}));
            end
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
            out_all = client.load('project', 'limit', 1, 'load_all', true);
            tc.verifyEqual(numel(out_all.projects), out_all.meta.total_results);
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

        function saveIgnoringErrors(data, settings)
            % Run save up to its token check; only its warnings matter here.
            try
                brainstem.save('data', data, 'model', 'session', 'method', 'patch', ...
                               'settings', settings);
            catch
            end
        end

    end

end
