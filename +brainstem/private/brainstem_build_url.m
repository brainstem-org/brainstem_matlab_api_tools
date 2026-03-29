function url = brainstem_build_url(base_url, portal, app, model, id)
% BRAINSTEM_BUILD_URL  Assemble a BrainSTEM REST endpoint URL.
%
%   url = brainstem_build_url(base_url, portal, app, model)
%   url = brainstem_build_url(base_url, portal, app, model, id)
%
%   When id is provided the URL points to the individual resource:
%       <base>/api/<portal>/<app>/<model>/<id>/
%   Otherwise it points to the collection:
%       <base>/api/<portal>/<app>/<model>/

if nargin < 5 || isempty(id)
    url = [base_url, 'api/', portal, '/', app, '/', model, '/'];
else
    url = [base_url, 'api/', portal, '/', app, '/', model, '/', id, '/'];
end
