function [url, token] = brainstem_env_settings()
% BRAINSTEM_ENV_SETTINGS  Server URL and token from the environment.
%
%   [url, token] = brainstem_env_settings()
%
%   The variables are the ones every BrainSTEM tool reads (the Python client, its
%   `brainstem` CLI, brainstem-nwb and the agent skills): BRAINSTEM_API_URL and
%   BRAINSTEM_API_TOKEN. The older MATLAB-only names BRAINSTEM_URL and BRAINSTEM_TOKEN
%   are still honoured when the shared ones are not set. url falls back to
%   https://www.brainstem.org/ and always ends with a slash; token is '' when unset.

url = first_set({'BRAINSTEM_API_URL', 'BRAINSTEM_URL'});
if isempty(url)
    url = 'https://www.brainstem.org/';
elseif url(end) ~= '/'
    url = [url '/'];
end
token = first_set({'BRAINSTEM_API_TOKEN', 'BRAINSTEM_TOKEN'});
end


function value = first_set(names)
value = '';
for i = 1:numel(names)
    value = strtrim(getenv(names{i}));
    if ~isempty(value)
        return
    end
end
end
