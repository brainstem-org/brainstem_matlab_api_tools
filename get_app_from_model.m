function app = get_app_from_model(modelname)
    
switch modelname
    case {'project','subject','session','collection','cohort'}
        app = 'stem';
    case {'procedure','equipment','consumablestock','behavior','dataacquisition','manipulation','procedurelog','subjectlog'}
        app = 'modules';
    case {'behavioralparadigm','datastorage','setup','inventory'}    
        app = 'personal_attributes';
    case {'consumable','hardwaredevice','supplier'}    
        app = 'resources';
    case {'brainregion','setuptype','species','strain'}    
        app = 'taxonomies';
    case {'journal','publication'}    
        app = 'dissemination';
    case {'user','laboratory'}    
        app = 'users';
    case {'group'}    
        app = 'auth';
    otherwise 
        app = '';
end
