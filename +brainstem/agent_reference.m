function text = agent_reference(page, varargin)
% AGENT_REFERENCE  One page of the server's agent reference, as text.
%
%   text = brainstem.agent_reference()                       % index.md
%   text = brainstem.agent_reference('resources/session.md')
%   text = brainstem.agent_reference('guides/query-syntax.md', 'url', 'http://127.0.0.1:8000/')
%
%   The server describes its own API and data model at <server>/reference/: Markdown
%   pages such as rules.md, resources/<resource>.md, schemas/<Family>/<Type>.md and
%   guides/<name>.md, and JSON documents under data/. The reference is public, so no
%   token is sent. The server defaults to BRAINSTEM_API_URL (or BRAINSTEM_URL).

p = inputParser;
addParameter(p, 'url', '', @ischar);
parse(p, varargin{:});
if nargin < 1 || isempty(page)
    page = 'index.md';
end
base = p.Results.url;
if isempty(base)
    base = brainstem_env_settings();
elseif base(end) ~= '/'
    base = [base '/'];
end
url = [base 'reference/' regexprep(page, '^/', '')];
options = weboptions('ContentType', 'text', 'Timeout', 30);
try
    text = char(webread(url, options));
catch ME
    if isequal(brainstem_http_status(ME), 404)
        error('BrainSTEM:agentReference', ['No agent reference page ''%s'' on this server. The page ' ...
            'does not exist, or the server predates the agent reference.'], page);
    end
    error('BrainSTEM:agentReference', 'API error fetching %s: %s', url, brainstem_parse_api_error(ME));
end
end
