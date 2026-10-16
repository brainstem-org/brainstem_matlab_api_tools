function output = export_session(session_id, varargin)
% EXPORT_SESSION  Download one session and everything it touches as a JSON export.
%
%   output = brainstem.export_session(SESSION_ID)
%   output = brainstem.export_session(SESSION_ID, 'background', true)
%   output = brainstem.export_session(SESSION_ID, 'file', 'session.json.gz')
%
%   Same format as EXPORT_PROJECT with export_info.scope 'session': the session with
%   its data acquisitions, manipulations, behaviors and epochs; the subjects and
%   specimen sets linked to it with their full procedure and log history (also after
%   the session); the session's projects you can read; and the lab resources, catalog
%   entries and users these reference. This is the content of one NWB file.
%
%   Parameters and errors are those of EXPORT_PROJECT. Exporting needs read access
%   to one of the session's projects.
output = brainstem_export('session', session_id, varargin{:});
end
