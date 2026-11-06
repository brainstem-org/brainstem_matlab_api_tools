function merged = brainstem_merge_records(a, b)
% BRAINSTEM_MERGE_RECORDS  Append the records of one page to those of earlier pages.
%
%   merged = brainstem_merge_records(a, b)
%
%   a and b are record lists as decoded from JSON: struct arrays, cell arrays of
%   structs, or [] for an empty list. Records whose id is already present are
%   skipped (sideloaded records repeat across pages). The result is a column
%   struct array when the records can be unified, else a column cell array.

records = [as_cell(a); as_cell(b)];
ids = cell(size(records));
for i = 1:numel(records)
    if isstruct(records{i}) && isfield(records{i}, 'id') && ischar(records{i}.id)
        ids{i} = records{i}.id;
    else
        ids{i} = sprintf('#%d', i);  % records without an id are always kept
    end
end
[~, first] = unique(ids, 'stable');
records = records(sort(first));

wrapper = brainstem_normalize_list_response(struct('records', {records}));
merged = wrapper.records;
if isstruct(merged) || iscell(merged)
    merged = merged(:);
end
end

function c = as_cell(records)
if isempty(records)
    c = {};
elseif iscell(records)
    c = records(:);
elseif isstruct(records)
    c = num2cell(records(:));
else
    c = {records};
end
end
