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
- **Loading Public Data:** Access public projects and data using the public portal, also anonymously.
- **Pagination:** Load all records across multiple pages automatically.
- **Exports:** Download a project or session as versioned JSON (format 2.1).
- **Agent reference:** Read the server's own description of its API.

## Authentication

### Recommended: Personal Access Token (scripts, HPC, automation)
Create a token at [brainstem.org/private/users/tokens/](https://www.brainstem.org/private/users/tokens/).
Tokens are valid for 1 year.

```matlab
% Option A: environment variable (set once per shell/session, or in .env / bashrc).
% BRAINSTEM_API_TOKEN is the variable every BrainSTEM tool reads (Python client,
% brainstem CLI, brainstem-nwb, agent skills); the older BRAINSTEM_TOKEN still works.
setenv('BRAINSTEM_API_TOKEN','<your_token>')
client = BrainstemClient();   % picks it up automatically

% Option B: pass directly
client = BrainstemClient('token','<your_token>');
```

> **Custom server URL** (local dev, staging):
> ```matlab
> setenv('BRAINSTEM_API_URL', 'http://localhost:8000/')   % or the older BRAINSTEM_URL
> client = BrainstemClient();   % uses the URL from the env var
> % or pass explicitly:
> client = BrainstemClient('url','http://localhost:8000/', 'token','<your_token>');
> ```
> The standalone `brainstem.*` functions honour the same variables (`brainstem.env_defaults()` shows
> what they resolve to).

### Public data without logging in
```matlab
client = BrainstemClient('anonymous', true);   % sends no token; only portal 'public' works
projects = client.load('project', 'portal', 'public', 'load_all', true);
```

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
| `brainstem.get_token` | Interactively acquire and cache an API token |
| `brainstem.logout` | Remove a cached token for a server URL |
| `brainstem.load` | Load records from any BrainSTEM model |
| `brainstem.save` | Create or update records (POST / PUT / PATCH) |
| `brainstem.delete` | Delete a record by UUID |
| `brainstem.export_project` | Download a project's JSON export (format 2.1), directly or as a background job |
| `brainstem.export_session` | Download one session's JSON export: the content of one NWB file |
| `brainstem.agent_reference` | Read a page of the server's public agent reference |
| `brainstem.env_defaults` | Server URL and token resolved from the environment |
| `brainstem.get_app_from_model` | Map a model name to its API app prefix |

## Convenience Loaders

These functions live in the `+brainstem` package. Call them as `brainstem.<name>(...)` or via the client as `client.<name>(...)`.

| Function | Model | Default includes (sideloaded) |
|----------|-------|-----------------|
| `brainstem.load_project` | project | sessions, subjects, collections, cohorts |
| `brainstem.load_subject` | subject | procedures, subjectlogs |
| `brainstem.load_session` | session | dataacquisition, behaviors, manipulations, epochs |
| `brainstem.load_collection` | collection | sessions |
| `brainstem.load_cohort` | cohort | subjects |
| `brainstem.load_behavior` | behavior (modules) | — |
| `brainstem.load_dataacquisition` | dataacquisition (modules) | — |
| `brainstem.load_manipulation` | manipulation (modules) | — |
| `brainstem.load_procedure` | procedure (modules) | — |
| `brainstem.load_procedurelog` | procedurelog (modules) | — |
| `brainstem.load_subjectlog` | subjectlog (modules) | — |
| `brainstem.load_equipment` | equipment (modules) | — |
| `brainstem.load_consumablestock` | consumablestock (modules) | — |

## Query Options

All `load` calls (and the convenience loaders) support:

| Parameter | Description | Example |
|-----------|-------------|---------|
| `filter` | `{field, value}` pairs | `{'name.icontains','Rat'}` |
| `sort` | field names; `-` prefix = descending | `{'-name'}` |
| `include` | relational fields to sideload (see below) | `{'behaviors','subjects'}` |
| `id` | UUID → fetches single record | `'c5547922-...'` |
| `limit` | records per page, 1 to 500 (default 100); sent as `per_page` | `50` |
| `offset` | records to skip, a multiple of `limit`; sent as `page` | `50` |
| `load_all` | fetch every page (and merge sideloaded records) | `true` |
| `portal` | `'private'` or `'public'` | `'public'` |

### Filter operators
Any operator the server supports, for example `icontains`, `iexact`, `in`, `startswith`, `gt`, `gte`, `lt`,
`lte`, `isnull` and `range`. The server lists them, with the include, sort and paging syntax, on the
`query-syntax.md` page of its agent reference (`brainstem.agent_reference('query-syntax.md')`).

Filter a relation by the bare field name: `{'projects', '<uuid>'}` sends `filter{projects}=<uuid>`, which every server accepts. The `filter{<relation>.id}` form fails on many relations on older servers.

### Convenience loader filters

| Function | Named filters |
|----------|---------------|
| `load_project` | `name`, `description`, `sessions`, `subjects`, `tags` |
| `load_subject` | `name`, `description`, `projects`, `strain`, `sex`, `tags` |
| `load_session` | `name`, `description`, `projects`, `datastorage`, `tags` |
| `load_collection`, `load_cohort` | `name`, `description`, `tags` |
| `load_behavior`, `load_dataacquisition`, `load_manipulation` | `session` |
| `load_procedure`, `load_subjectlog` | `subject` (`load_subjectlog` also `type`, `description`) |
| `load_procedurelog` | `procedure` |
| `load_equipment` | `name`, `setup` |
| `load_consumablestock` | `inventory` |

`tags` filters by tag name (sent as `filter{tags.name}`); records return their tags as names. Use `{'tags.name.in', ...}` or `{'tags.name.icontains', ...}` through `filter` for other forms.

### Lists read with include

Sending a list field (`projects`, `subjects`, `behaviors`, ...) with `save` replaces the whole list. A record loaded with `include`, which the `load_project`, `load_subject`, `load_session`, `load_collection` and `load_cohort` defaults use, lists only the related records you may read. Saving that list would remove links you cannot see. `load` marks such records with a `brainstem_included` field; `save` removes it and warns (`BrainSTEM:save:partialList`) when it sends one of those lists. Reload the record without `include` before changing a list field.

### Models

Every REST resource of the server can be loaded and saved by name, including the specimen-era ones: `specimenset`, `specimen`, `epoch`, `sessiondatastorage`, `experimentalinterface`, `materialusage`, `specimenprocedure`, `specimenlog`, `procedureepisode`, `anatomicalregion`, `anatomicalreference`, `coordinatetransform`, the link tables and the templates. `brainregion` is the deprecated name of `anatomicalregion`: `load`, `save` and `delete` still accept it, with a warning, and use `anatomicalregion`.

### Exports and the agent reference

```matlab
% One JSON document (format 2.1) with every record of the project you may read.
export = client.export_project('<project_uuid>');
export.export_info.record_count

% Keep the original JSON for brainstem-nwb (the returned struct has jsondecode's
% sanitized field names, e.g. records.stem_project instead of "stem.project").
client.export_project('<project_uuid>', 'file', 'project-export.json.gz');

% Large projects exceed the server's 30-second request limit: queue a job and wait.
export = client.export_project('<project_uuid>', 'background', true);

% One session and everything it touches (the content of one NWB file).
session_export = client.export_session('<session_uuid>');

% The server's own description of its API and data model, written for AI agents.
disp(client.agent_reference('index.md'))
disp(client.agent_reference('resources/session.md'))
```

Exports need read access to the project (or to one of the session's projects) and a server with the
export API; the agent reference needs a server that publishes it at `<server>/reference/`.

### Known limitations

- Specimen-era models, exports and the agent reference need a server with the specimen release; older servers answer 404 for them.
- `offset` must be a multiple of the page size, and a page holds at most 500 records. Use `load_all` to get everything.
- Records copied into a new struct lose the `brainstem_included` mark, so `save` cannot warn about them.

## Example Usage

```matlab
client = BrainstemClient('token', getenv('BRAINSTEM_TOKEN'));

% Load ALL sessions (follows every page; out.meta.total_results is the total)
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

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contributing
Contributions are welcome! Feel free to open issues or submit pull requests on GitHub.

