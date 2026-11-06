function output = export_project(project_id, varargin)
% EXPORT_PROJECT  Download a project's versioned JSON export (format 2.1).
%
%   output = brainstem.export_project(PROJECT_ID)
%   output = brainstem.export_project(PROJECT_ID, 'background', true)
%   output = brainstem.export_project(PROJECT_ID, 'file', 'export.json.gz')
%
%   Returns the same document as the website's Project -> Download -> JSON, decoded
%   with jsondecode: output.export_info (format_version, exported_at, scope,
%   project_id, project_ids, session_id, lab_resources, restricted, record_count,
%   counts) and output.records. jsondecode turns the model labels that key the
%   records ('stem.project') into valid field names ('stem_project'); the file
%   written with 'file' keeps the original JSON, which brainstem-nwb and other tools
%   read as is.
%
%   Parameters:
%     background    - true to queue the export as a server job, wait for it and
%                     download the result. Use it for large projects, which exceed
%                     the server's 30-second request limit (default false).
%     file          - Path to write the raw export to ('.json' or '.json.gz').
%     poll_interval - Seconds between job status checks (default 5).
%     timeout       - Maximum seconds to wait for the job (default 3600).
%     settings      - Settings struct (auto-resolved from the environment or token cache).
%
%   Exporting needs read access to the project. Errors raise BrainSTEM:export.
output = brainstem_export('project', project_id, varargin{:});
end
