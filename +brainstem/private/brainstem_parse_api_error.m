function msg = brainstem_parse_api_error(ME)
% BRAINSTEM_PARSE_API_ERROR  Extract a human-readable message from an API error.
%
%   Modern MATLAB (R2020b+) includes the HTTP response body in the
%   MException message when webread/webwrite encounters an HTTP error.
%   This helper extracts and formats any JSON validation detail from that
%   message, falling back to the raw message if no JSON is found.
%
%   Example API error body included by MATLAB:
%     {"name": ["This field is required."], "session": ["This field is required."]}
%   Formatted output:
%     'name: This field is required. | session: This field is required.'

raw = ME.message;

% Collapse newlines so the regex can match JSON that spans multiple lines
raw_clean = regexprep(raw, '\r?\n', ' ');

% Try to extract and format a JSON validation body first — this gives the
% most actionable information (field-level errors from DRF).  We do this
% before the HTTP-status check so that 400 responses with a body like:
%   "status 400 with message "Bad Request"  {"name":["required"]}"
% still surface the field-level detail rather than just "400 Bad Request".
json_match = regexp(raw_clean, '\{.+\}', 'match', 'once');
json_msg   = '';

if ~isempty(json_match)
    try
        err_struct = jsondecode(json_match);
        fields = fieldnames(err_struct);
        parts  = cell(1, numel(fields));
        for i = 1:numel(fields)
            val = err_struct.(fields{i});
            if iscell(val)
                % Array of error strings from DRF: ["This field is required."]
                val_str = strjoin(val, '; ');
            elseif ischar(val)
                val_str = val;
            elseif isstruct(val)
                % Nested object — flatten one level
                sub_fields = fieldnames(val);
                sub_parts  = cell(1, numel(sub_fields));
                for j = 1:numel(sub_fields)
                    sv = val.(sub_fields{j});
                    if iscell(sv)
                        sub_parts{j} = sprintf('%s: %s', sub_fields{j}, strjoin(sv, '; '));
                    elseif ischar(sv)
                        sub_parts{j} = sprintf('%s: %s', sub_fields{j}, sv);
                    else
                        sub_parts{j} = sprintf('%s: %s', sub_fields{j}, jsonencode(sv));
                    end
                end
                val_str = strjoin(sub_parts, '; ');
            else
                val_str = num2str(val);
            end
            parts{i} = sprintf('%s: %s', fields{i}, val_str);
        end
        json_msg = strjoin(parts, ' | ');
    catch
        % JSON parse failed — fall through
    end
end

% Extract HTTP status code / reason if present in the message.
http_match = regexp(raw_clean, 'status (\d+) with message "([^"]+)"', 'tokens', 'once');

if ~isempty(json_msg)
    % Have parsed JSON details.  Optionally prepend the status code so the
    % caller still knows which HTTP error triggered this.
    if ~isempty(http_match)
        msg = sprintf('%s %s — %s', http_match{1}, http_match{2}, json_msg);
    else
        msg = json_msg;
    end
    return
end

if ~isempty(http_match)
    % No JSON body, but we have the HTTP status.
    msg = sprintf('%s %s', http_match{1}, http_match{2});
    return
end

% Fallback: return the raw message unchanged
msg = raw;
end
