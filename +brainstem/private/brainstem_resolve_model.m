function model = brainstem_resolve_model(model)
% BRAINSTEM_RESOLVE_MODEL  Server name of MODEL, resolving deprecated names with a warning.
%
%   model = brainstem_resolve_model(model)
%
%   'brainregion' was renamed 'anatomicalregion' on the server.

if strcmp(model, 'brainregion')
    warning('BrainSTEM:deprecatedModel', ...
        '''brainregion'' is deprecated; use ''anatomicalregion''.');
    model = 'anatomicalregion';
end
end
