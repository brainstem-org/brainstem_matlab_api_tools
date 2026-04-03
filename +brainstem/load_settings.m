function settings = load_settings()
% LOAD_SETTINGS  Deprecated. Use the BRAINSTEM_TOKEN environment variable or
%   BrainstemClient instead. This function now delegates to the internal
%   brainstem_get_settings() helper.
%
%   To set a custom server URL, set the BRAINSTEM_URL environment variable:
%     setenv('BRAINSTEM_URL', 'http://localhost:8000/')
%
%   See also: BrainstemClient, brainstem.get_token
warning('BrainSTEM:deprecated', ...
    ['brainstem.load_settings() is deprecated. Set the BRAINSTEM_TOKEN ' ...
     'environment variable and use BrainstemClient or brainstem.load() directly.']);
settings = brainstem_get_settings();
end

