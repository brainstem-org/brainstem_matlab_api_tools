# Changelog

## 2.1 (unreleased)

Server requirements: BrainSTEM with the `specimen-1` data model, the project/session export API
(format 2.1) and the public agent reference (`/reference/`).

### Added
- `brainstem.export_project`, `brainstem.export_session` and the matching client methods: direct or
  background-job exports, optional `'file'` output keeping the original JSON for `brainstem-nwb`.
- `brainstem.agent_reference` and `client.agent_reference(page)`: read the server's public agent
  reference without a token.
- `BrainstemClient('anonymous', true)` for public reads without a login.
- `brainstem.env_defaults`: the server URL and token resolved from the environment.
- Routes for the specimen data model, interfaces, materials, episodes, coordinates and anatomical
  references; `brainregion` remains as a deprecated alias of `anatomicalregion`.
- page/per_page paging (`limit`/`offset`), `load_all` merging of sideloaded lists, and the
  `brainstem_included` mark that lets `save` warn before overwriting a partially read list.

### Changed
- Environment variables: `BRAINSTEM_API_TOKEN` and `BRAINSTEM_API_URL`, shared with the Python client,
  its `brainstem` CLI, `brainstem-nwb` and the agent skills, are read first. `BRAINSTEM_TOKEN` and
  `BRAINSTEM_URL` still work.
- The named `tags` filter of the loaders filters by tag name (`filter{tags.name}`), which the server now
  supports; tag ids were never returned by the API.
- Only a 401 response triggers a new login. A 403 (permission denied) or an unrelated error whose text
  happened to contain "401" used to open the browser login.
- A device-login poll that fails with 400 (`invalid_device_code`) or 500 now raises at once instead of
  waiting for the 15-minute timeout.
- Consumable stock list responses are read under the server's current key `consumable_stocks`.
- `disp(client)` no longer prints part of the token.

## 2.0 (March 2026)

- Browser-based device authorization with 2FA; token cached in `prefdir`.
- `BrainstemClient` class and `brainstem.*` package functions with convenience loaders.
