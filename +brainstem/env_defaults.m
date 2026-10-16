function [url, token] = env_defaults()
% ENV_DEFAULTS  Server URL and token the BrainSTEM tools read from the environment.
%
%   [url, token] = brainstem.env_defaults()
%
%   Reads BRAINSTEM_API_URL and BRAINSTEM_API_TOKEN, the variables shared with the
%   Python client, its `brainstem` CLI, brainstem-nwb and the agent skills. The older
%   MATLAB names BRAINSTEM_URL and BRAINSTEM_TOKEN are honoured when those are unset.
%   url defaults to https://www.brainstem.org/; token is '' when no variable is set.

[url, token] = brainstem_env_settings();
end
