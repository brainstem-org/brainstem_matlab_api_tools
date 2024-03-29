function app = get_app_from_model(modelname)
    
switch modelname
    case {'project','subject','dataset','collection'}
        app = 'stem';
    case {'action','behavior','experimentdata','manipulation','subjectstatechange','actionlog','subjectlog'}
        app = 'modules';
    case {'behavioralparadigm','datarepository','physicalenvironment'}    
        app = 'personal_attributes';
    case {'consumable','hardwaredevice','supplier'}    
        app = 'resources';
    case {'brainregion','environmenttype','sensorystimulustype','species','strain'}    
        app = 'taxonomies';
    case {'journal','laboratory','publication'}    
        app = 'attributes';
    case {'user'}    
        app = 'users';
    case {'group'}    
        app = 'auth';
    otherwise 
        app = '';
end
