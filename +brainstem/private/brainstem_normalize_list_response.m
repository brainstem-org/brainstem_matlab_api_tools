function response = brainstem_normalize_list_response(response)
% BRAINSTEM_NORMALIZE_LIST_RESPONSE  Ensure data arrays in a list response
% are always struct arrays, never cell arrays.
%
% MATLAB's webread/jsondecode decodes JSON arrays inconsistently:
%   - multiple records with identical fields  → 1×N struct array  (ideal)
%   - single record                           → 1×1 struct        (fine)
%   - records with heterogeneous fields       → cell array        (problem)
%
% This function converts cell arrays to struct arrays where possible.
% If unification fails (truly incompatible types), the field is left as a
% cell array rather than silently dropping data.

metadata_keys = {'count', 'next', 'previous'};
fn = fieldnames(response);
for k = 1:numel(fn)
    key = fn{k};
    if ismember(key, metadata_keys)
        continue
    end
    val = response.(key);
    if ~iscell(val)
        continue
    end
    % Only try to unify cells whose elements are all structs.
    all_structs = all(cellfun(@isstruct, val(:)));
    if ~all_structs
        continue
    end
    % Add any missing fields (as []) so all records share the same schema,
    % then concatenate into a struct array.
    try
        all_fields_cells = cellfun(@fieldnames, val(:), 'UniformOutput', false);
        all_fields = unique(vertcat(all_fields_cells{:}));
        for j = 1:numel(val)
            for fi = 1:numel(all_fields)
                f = all_fields{fi};
                if ~isfield(val{j}, f)
                    val{j}.(f) = [];
                end
            end
        end
        response.(key) = [val{:}];
    catch
        % Leave as cell — records have truly incompatible schemas.
    end
end
end
