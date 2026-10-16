function status = brainstem_http_status(ME)
% BRAINSTEM_HTTP_STATUS  HTTP status code behind a webread/webwrite error, or [].
%
%   status = brainstem_http_status(ME)
%
%   MATLAB reports HTTP failures as 'status NNN with message "..."'. Errors already
%   wrapped by this package ('API error ...: NNN Reason ...') are recognised too.

status = [];
tok = regexp(ME.message, 'status (\d{3}) with message', 'tokens', 'once');
if isempty(tok)
    tok = regexp(ME.message, ': (\d{3}) [A-Z]', 'tokens', 'once');
end
if ~isempty(tok)
    status = str2double(tok{1});
end
end
