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
Tokens are valid for 1 year.

```matlab
% Option A: environment variable (set once per shell/session, or in .env / bashrc)
setenv('BRAINSTEM_TOKEN','<your_token>')
client = BrainstemClient();   % picks it up automatically

% Option B: pass directly
client = BrainstemClient('token','<your_token>');
```

> **Custom server URL** (local dev, staging):
> ```matlab
> setenv('BRAINSTEM_URL', 'http://localhost:8000/')
> client = BrainstemClient();   % uses the URL from the env var
> % or pass explicitly:
> client = BrainstemClient('url','http://localhost:8000/', 'token','<your_token>');
> ```
> The standalone `brainstem.*` functions also honour `BRAINSTEM_URL`.

### Interactive login (device flow, desktop MATLAB)
```matlab
client = BrainstemClient();   % opens browser login page
```

## BrainstemClient (recommended)

Create the client once; it holds the token and base URL for all subsequent calls:

```matlab
client = BrainstemClient('token', getenv('BRAINSTEM_TOKEN'));

% Load sessions
out = client.load('session');

% Partial update
patch_data.id = out.sessions(1).id;
patch_data.description = 'updated';
client.save(patch_data, 'session', 'method', 'patch');

% Delete
client.delete(out.sessions(1).id, 'session');
```

## Core Functions Overview

| Function | Description |
|----------|-------------|
| `BrainstemClient` | Client class — authenticate once, call any endpoint |
| `get_token` | Interactively acquire and cache an API token |
| `brainstem.load` | Load records from any BrainSTEM model |
| `brainstem.save` | Create or update records (POST / PUT / PATCH) |
| `brainstem.delete` | Delete a record by UUID |
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

All `load` calls (and the convenience loaders) support:

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
out = client.load('session', 'load_all', true);

% Filter + sort + include
out = client.load('session', ...
    'filter',  {'name.icontains', 'Rat'}, ...
    'sort',    {'-name'}, ...
    'include', {'projects','behaviors'});

% Single record by UUID
out = client.load('session', 'id', '<session_uuid>');

% Convenience loaders (tab-completable, credentials automatic)
sessions  = client.load_session('name', 'mysession');
behaviors = client.load_behavior('session', '<session_uuid>');

% Create
s.name = 'My new session'; s.projects = {'<proj_uuid>'}; s.tags = [];
out = client.save(s, 'session');

% Partial update (PATCH)
patch.id = out.id; patch.description = 'updated';
client.save(patch, 'session', 'method', 'patch');

% Delete
client.delete(out.id, 'session');

% Public data
public_projects = client.load('project', 'portal', 'public');
```

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contributing
Contributions are welcome! Feel free to open issues or submit pull requests on GitHub.

