# Matlab toolset for interacting with the BrainSTEM API
Please see the dedicated [documentation of the tool and api](https://support.brainstem.org/api-tools/matlab-api-tool/).

Please see the tutorial script `brainstem_api_tutorial.m` for example calls.

# Examples calls

### 0. Setup credentials/token: 

Email and password will be requested

```m
get_token
```

The token is saved to a mat file (`brainstem_authentication.mat`) in the Matlab API tool folder.

### 1. Loading sessions

`load_model` can be used to load any model: We just need to set the name of the model.

```m
output1 = load_model('model','session');
```

We can fetch a single session entry from the loaded models.

```m
session = output1.sessions(1);
```

We can also filter the models by providing cell array with paired filters In this example, it will just load sessions whose name is "yeah".

```m
output1_1 = load_model('model','session','filter',{'name','yeah'});
```

Loaded models can be sorted by different criteria applying to their fields. In this example, sessions will be sorted in descending ording according to their name.

```m
output1_2 = load_model('model','session','sort',{'-name'});
```

In some cases, models contain relations with other models, and they can be loaded with the models if requested. In this example, all the projects, data acquisition, behaviors, and manipulations related to each session will be included.

```m
output1_3 = load_model('model','session','include',{'projects','dataacquisition','behaviors','manipulations'});
```

The list of related data acquisition can be retrieved from the returned dictionary.

```m
dataacquisition = output1_3.dataacquisition;
```

Get all subjects with related procedures

```m
output1_4 = load_model('model','subject','include',{'procedures'});
```

Get all projects with related subjects and sessions

```m
output1_5 = load_model('model','project','include',{'sessions','subjects'});
```

All these options can be combined to suit the requirements of the users. For example, we can get only the session that contain the word "Rat" in their name, sorted in descending order by their name and including the related projects.

```m
output1_6 = load_model('model','session', 'filter',{'name.icontains', 'Rat'}, 'sort',{'-name'}, 'include',{'projects'});
```

### 2. Updating a session

We can make changes to a model and update it in the database. In this case, we change the description of one of the previously loaded sessions.

```m
session = output1.sessions(1);
session.description = 'new description';
output2 = save_model('data',session,'model','session');
```

### 3. Creating a new session

We can submit a new entry by defining a struct with the required fields.

```m
session = {};
session.name = 'New session85';
session.description = 'new session description';
session.projects = {'0c894095-2d16-4bde-ad50-c33b7680417d'};
```

Submitting session

```m
output3 = save_model('data',session,'model','session');
```

### 4. Load public projects

Request the public data by defining the portal to be public

```m
output4 = load_model('model','project','portal','public');
```
