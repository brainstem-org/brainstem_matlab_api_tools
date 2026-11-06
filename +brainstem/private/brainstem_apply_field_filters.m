function filter = brainstem_apply_field_filters(parameters, extra_fields, filter_map)
% BRAINSTEM_APPLY_FIELD_FILTERS  Translate named parameters into filter pairs.
%
%   filter = brainstem_apply_field_filters(parameters, extra_fields, filter_map)
%
%   parameters  - struct from inputParser containing the named values
%   extra_fields - cell array of field names to check, e.g. {'id','name','tags'}
%   filter_map  - n×2 cell array mapping field name → filter key, e.g.
%                 {'id',          'id';
%                  'name',        'name.icontains';
%                  'tags',        'tags'}
%                 Fields not listed in filter_map default to '<field>.icontains'.
%
%   Returns the updated filter cell array (appended to parameters.filter).

filter = parameters.filter;
% A flat {key, value, key, value, ...} filter becomes N×2 so named filters can be appended.
if ~isempty(filter) && isvector(filter) && mod(numel(filter), 2) == 0
    filter = reshape(filter, 2, [])';
end

% Build a quick lookup: field -> filter key
lookup = containers.Map(filter_map(:,1), filter_map(:,2));

for i = 1:numel(extra_fields)
    field = extra_fields{i};
    value = parameters.(field);
    if ~isempty(value)
        if isKey(lookup, field)
            key = lookup(field);
        else
            key = [field, '.icontains'];
        end
        filter = [filter; {key, value}]; %#ok<AGROW>
    end
end
