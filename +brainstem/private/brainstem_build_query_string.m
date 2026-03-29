function qs = brainstem_build_query_string(filter, sort, include, limit, offset)
% BRAINSTEM_BUILD_QUERY_STRING  Build a URL query string from API parameters.
%
%   qs = brainstem_build_query_string(filter, sort, include, limit, offset)
%
%   All inputs are optional (pass [] or {} to omit).
%
%   filter  - cell array of {field, value} pairs, e.g. {'name','session1','tags','1'}
%   sort    - cell array of field names, prefix '-' for descending, e.g. {'-name'}
%   include - cell array of relational fields to embed, e.g. {'behaviors','subjects'}
%   limit   - scalar integer, max records per page (API default: 20, max: 100)
%   offset  - scalar integer, number of records to skip

parts = {};

% Filter parameters: filter{field}=value
if ~isempty(filter)
    for i = 1:2:numel(filter)
        parts{end+1} = ['filter{', filter{i}, '}=', urlencode(num2str(filter{i+1}))]; %#ok<AGROW>
    end
end

% Sort parameters: sort[]=field
if ~isempty(sort)
    for i = 1:numel(sort)
        parts{end+1} = ['sort[]=', sort{i}]; %#ok<AGROW>
    end
end

% Include parameters: include[]=relation.*
if ~isempty(include)
    for i = 1:numel(include)
        parts{end+1} = ['include[]=', include{i}, '.*']; %#ok<AGROW>
    end
end

% Pagination
if nargin >= 4 && ~isempty(limit)
    parts{end+1} = ['limit=', num2str(limit)];
end
if nargin >= 5 && ~isempty(offset) && offset > 0
    parts{end+1} = ['offset=', num2str(offset)];
end

if isempty(parts)
    qs = '';
else
    qs = ['?', strjoin(parts, '&')];
end
