## ADDED Requirements

### Requirement: Uniform repository notation
All lazy.nvim plugin specs SHALL declare the repository using the full Git HTTPS URL (e.g., `https://github.com/owner/repo.git`), not shorthand `owner/repo` or `name` forms.

#### Scenario: Loading any plugin spec
- **WHEN** a plugin spec is read by lazy.nvim
- **THEN** its `url` (or repository field) is a full Git HTTPS URL

### Requirement: Typed plugin tables
Every exported plugin table (single or list entry) SHALL be preceded by a LuaDoc type annotation using `LazyPluginSpec` (or `LazyPluginSpec[]` for lists) to describe its shape.

#### Scenario: Declaring a plugin spec in a file
- **WHEN** a plugin table is defined for lazy.nvim
- **THEN** it is immediately preceded by `---@type LazyPluginSpec` (or `LazyPluginSpec[]` when returning a list)

### Requirement: Named, typed dependencies
Each dependency included in a plugin spec SHALL be defined as its own named Lua table that follows the same style requirements (full URL, pin, type annotation, opts-as-function). Inline anonymous dependency tables SHALL NOT be used.

#### Scenario: Adding a dependency to a plugin
- **WHEN** a dependency is referenced in `dependencies`
- **THEN** it is a named local table with `---@type LazyPluginSpec`, full URL, and tag/commit pin, and that table is inserted into the dependencies list

### Requirement: List returns
Each plugin spec module SHALL return a `LazyPluginSpec[]` list, even when only a single plugin is present, to allow future growth without reshaping callers.

#### Scenario: Requiring a plugin spec module
- **WHEN** a plugin spec module is required
- **THEN** it returns a list (`LazyPluginSpec[]`) containing one or more typed plugin tables

### Requirement: Function-form opts
Plugin options provided to lazy.nvim SHALL be expressed as `opts = function() return { ... } end` rather than inline tables, preserving existing option values.

#### Scenario: Setting plugin options
- **WHEN** a plugin defines configuration options
- **THEN** the options are returned from an `opts` function that yields the previous option values

### Requirement: File export pattern
Each plugin spec file SHALL return the plugin table directly (one spec per file when practical) following the `lua/plugins/colorscheme.lua` pattern; multi-spec files SHALL still return a table and type-annotate each entry.

#### Scenario: Requiring a plugin spec module
- **WHEN** a plugin spec module is required
- **THEN** it returns the plugin table (or list) with the required type annotations and consistent field ordering
