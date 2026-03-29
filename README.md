# BrainSTEM MATLAB API Tools

The `brainstem_matlab_api_tools` is a MATLAB toolset for interacting with the BrainSTEM API, designed for researchers and developers working with neuroscience data.

## Installation
Download the repository and add the **root folder** to your MATLAB path:

```matlab
addpath('/path/to/brainstem_matlab_api_tools')
```

> Only the root needs to be added. MATLAB automatically discovers the `+brainstem` package folder and the `BrainstemClient` class inside it. Do **not** add `+brainstem/` itself to the path.

## Getting Started
To get started, refer to the tutorial script `brainstem_api_tutorial.m` for example usage.

The tutorial demonstrates how to:

- **Authenticate:** Using a Personal Access Token or interactive credentials.
- **Loading Data:** Load sessions and filter data using flexible options.
- **Updating Entries:** Partially or fully update existing records.
- **Creating Entries:** Submit new data entries with required fields.
- **Deleting Entries:** Remove records by UUID.
- **Loading Public Data:** Access public projects and data using the public portal.
- **Pagination:** Load all records across multiple pages automatically.

## Authentication

### Recommended: Personal Access Token (scripts, HPC, automation)
Create a token at [brainstem.org/private/users/tokens/](https://www.brainstem.org/private/users/tokens/).
Tokens are valid for 1 year and auto-refresh.

```matlab
% Option A: environment variable (set once per shell/session)
setenv('BRAINSTEM_TOKEN','<your_token>')
client = BrainstemClient();

% Option B: pass directly
client = BrainstemClient('token','<your_token>');
```

### Interactive login (desktop MATLAB, GUI dialog)
```matlab
client = BrainstemClient();   % opens a credential dialog
```

## BrainstemClient (recommended)

Create the client once; it holds the token and base URL for all subsequent calls:

```matlab
client = BrainstemClient('token', getenv('BRAINSTEM_TOKEN'));

% Load sessions
out = client.load_model('session');

% Partial update
patch_data.id = out.sessions(1).id;
patch_data.description = 'updated';
client.save_model(patch_data, 'session', 'method', 'patch');

% Delete
client.delete_model(out.sessions(1).id, 'session');
```

## Core Functions Overview

| Function | Description |
|----------|-------------|
| `BrainstemClient` | Client class — authenticate once, call any endpoint |
| `get_token` | Interactively acquire and cache an API token |
| `load_model` | Load records from any BrainSTEM model |
| `save_model` | Create or update records (POST / PUT / PATCH) |
| `delete_model` | Delete a record by UUID |
| `load_settings` | Load settings struct (URL + token) from cache |
| `get_app_from_model` | Map a model name to its API app prefix |

## Convenience Loaders

| Function | Model | Default includes |
|----------|-------|-----------------|
| `load_project` | project | sessions, subjects, collections, cohorts |
| `load_subject` | subject | procedures, subjectlogs |
| `load_session` | session | dataacquisition, behaviors, manipulations, epochs |
| `load_collection` | collection | sessions |
| `load_cohort` | cohort | subjects |
| `load_behavior` | behavior (modules) | — |
| `load_dataacquisition` | dataacquisition (modules) | — |
| `load_manipulation` | manipulation (modules) | — |
| `load_procedure` | procedure (modules) | — |

## Query Options

All `load_model` calls (and the convenience loaders) support:

| Parameter | Description | Example |
|-----------|-------------|---------|
| `filter` | `{field, value}` pairs | `{'name.icontains','Rat'}` |
| `sort` | field names; `-` prefix = descending | `{'-name'}` |
| `include` | relational fields to embed | `{'behaviors','subjects'}` |
| `id` | UUID → fetches single record | `'c5547922-...'` |
| `limit` | max records per page (max 100) | `50` |
| `offset` | records to skip | `20` |
| `load_all` | auto-follow pagination | `true` |
| `portal` | `'private'` or `'public'` | `'public'` |

### Filter operators
`icontains`, `startswith`, `endswith`, `gt`, `gte`, `lt`, `lte`

## Example Usage

```matlab
client = BrainstemClient('token', getenv('BRAINSTEM_TOKEN'));

% Load ALL sessions (auto-paginate)
out = client.load_model('session', 'load_all', true);

% Filter + sort + include
out = client.load_model('session', ...
    'filter',  {'name.icontains', 'Rat'}, ...
    'sort',    {'-name'}, ...
    'include', {'projects','behaviors'});

% Single record by UUID
out = client.load_model('session', 'id', 'c5547922-c973-4ad7-96d3-72789f140024');

% Convenience loader
sessions = load_session('name', 'mysession');
behaviors = load_behavior('session', 'c5547922-c973-4ad7-96d3-72789f140024');

% Create
s.name = 'My new session'; s.projects = {'<proj_uuid>'}; s.tags = [];
out = client.save_model(s, 'session');

% Partial update (PATCH)
patch.id = out.id; patch.description = 'updated';
client.save_model(patch, 'session', 'method', 'patch');

% Delete
client.delete_model(out.id, 'session');

% Public data
public_projects = client.load_model('project', 'portal', 'public');
```

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contributing
Contributions are welcome! Feel free to open issues or submit pull requests on GitHub.

