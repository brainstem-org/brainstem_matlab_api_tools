function [per_page, page] = brainstem_page_params(limit, offset)
% BRAINSTEM_PAGE_PARAMS  Translate limit/offset into the API's per_page/page.
%
%   [per_page, page] = brainstem_page_params(limit, offset)
%
%   The API pages with page and per_page (default 100, maximum 500). limit is
%   the page size (100 when empty) and offset must be a multiple of it, which
%   works on every server version: page = offset / per_page + 1.

if nargin < 1 || isempty(limit),  limit  = 100; end
if nargin < 2 || isempty(offset), offset = 0;   end
per_page = limit;
if per_page < 1 || per_page > 500 || per_page ~= fix(per_page)
    error('BrainSTEM:load', ...
        'limit must be an integer from 1 to 500 (the API''s maximum page size), got %g.', per_page);
end
if offset < 0 || mod(offset, per_page) ~= 0
    error('BrainSTEM:load', ...
        'offset (%g) must be a multiple of limit (the page size, %d): the API pages with page/per_page.', ...
        offset, per_page);
end
page = offset / per_page + 1;
end
