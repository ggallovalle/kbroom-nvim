## ADDED Requirements

### Requirement: Tag-based pinning
Every lazy.nvim plugin SHALL be pinned to a git tag via the `tag` field; if no suitable tag exists, the plugin SHALL be pinned to a `commit` hash with rationale recorded. The `version` field SHALL be reserved for semver/range selectors and SHALL NOT be used for tag pins.

#### Scenario: Resolving a plugin version
- **WHEN** lazy.nvim installs or updates a plugin
- **THEN** it uses the tag specified in `tag` (or the documented `commit` hash when tags are unavailable)

### Requirement: Tag metadata annotation
Each pinned tag SHALL be documented with a comment adjacent to the spec stating the tag name, its release date, and a URL to the tag or commit. The same rule applies to dependencies defined as separate tables.

#### Scenario: Reviewing a plugin spec
- **WHEN** a reviewer inspects a plugin spec
- **THEN** they see a comment above the `tag`/`commit` field containing the tag name, release date, and tag/commit URL

### Requirement: No plugin churn
The refactor SHALL retain the existing plugin set; no plugins may be added or removed as part of this change.

#### Scenario: Comparing plugin list pre/post change
- **WHEN** the plugin inventory is diffed before and after refactoring
- **THEN** the set of plugin repositories remains identical
