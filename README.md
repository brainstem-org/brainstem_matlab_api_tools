# BrainSTEM MATLAB API Tools

The `brainstem_matlab_api_tools` is a MATLAB toolset for interacting with the BrainSTEM API, designed for researchers and developers working with neuroscience data.

## Installation
Download the repository and add the folder to your MATLAB path.

## Getting Started
To get started, refer to the tutorial script `brainstem_api_tutorial.m` for example usage.

The tutorial demonstrates how to:

- **Authenticate:** Authentication with your credentials.
- **Loading Data:** Load sessions and filter data using flexible options.
- **Updating Entries:** Modify existing models and update them in the database.
- **Creating Entries:** Submit new data entries with required fields.
- **Loading Public Data:** Access public projects and data using the public portal.

### Setup Credentials/Token
Run the `get_token` command. You will be prompted to enter your email and password. The token will be saved in a `.mat` file (`brainstem_authentication.mat`) in the MATLAB API tool folder.

## Core Functions Overview
The main functions provided by the BrainSTEM MATLAB API tools are:

| Function | Description |
|----------|-------------|
| `get_token` | Get and save authentication token |
| `load_model` | Load data from any model |
| `save_model` | Save data to any model |
| `load_settings` | Load local settings including API token, server URL, and local storage |
| `load_project` | Load project(s) with extra filters and relational data options |
| `load_subject` | Load subject(s) with extra filters and relational data options |
| `load_session` | Load session(s) with extra filters and relational data options |
| `brainstem_api_tutorial` | Tutorial script with example calls |

## Example Usage

### Loading Sessions
You can load models using `load_model`. Example:
```matlab
output1 = load_model('model','session');
session = output1.sessions(1);
```

### Filtering and Sorting
You can filter and sort results:
```matlab
output1_1 = load_model('model','session','filter',{'name','yeah'});
output1_2 = load_model('model','session','sort',{'-name'});
```

### Including Related Models
You can load related models as well:
```matlab
output1_3 = load_model('model','session','include',{'projects','dataacquisition','behaviors','manipulations'});
dataacquisition = output1_3.dataacquisition;
```

### Using Convenience Functions
For easier access, the API provides convenience functions:

```matlab
output = load_project('name','myproject');
output = load_subject('name','mysubject');
output = load_session('name','mysession');
```
These functions are equivalent to detailed API calls using `load_model` with filters and included relational data.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contributing
Contributions are welcome! Feel free to open issues or submit pull requests on GitHub.

