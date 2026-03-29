function app = get_app_from_model(modelname)
    
switch modelname
    case {'project','subject','session','collection','cohort', ...
          'breeding','projectmembershipinvitation','projectgroupmembershipinvitation'}
        app = 'stem';
    case {'procedure','equipment','consumablestock','behavior','dataacquisition','manipulation','procedurelog','subjectlog'}
        app = 'modules';
    case {'behavioralassay','datastorage','setup','inventory','license','protocol'}    
        app = 'personal_attributes';
    case {'consumable','hardwaredevice','supplier'}    
        app = 'resources';
    case {'brainregion','setuptype','species','strain','behavioralcategory','behavioralparadigm','regulatoryauthority'}    
        app = 'taxonomies';
    case {'journal','publication'}    
        app = 'dissemination';
    case {'user','laboratory','groupmembershipinvitation','groupmembershiprequest'}    
        app = 'users';
    case {'group'}    
        app = 'auth';
    otherwise 
        app = '';
end
