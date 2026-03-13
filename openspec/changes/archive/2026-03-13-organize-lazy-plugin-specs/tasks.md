## 1. Inventory and planning

- [x] 1.1 List all existing lazy.nvim plugin spec files under `lua/plugins/**` and note the plugin set to ensure no churn.
- [x] 1.2 For each plugin, record the currently locked commit (from `lazy-lock.json`) and check for available tags near that commit.

## 2. Normalize spec structure

- [x] 2.1 Replace shorthand repo identifiers with full Git HTTPS URLs in every plugin spec.
- [x] 2.2 Add `---@type LazyPluginSpec` (or `LazyPluginSpec[]`) annotations and return a `LazyPluginSpec[]` list from each module, even when it contains a single entry.
- [x] 2.3 Define each dependency as a named, typed table (full URL + pin) and reference those tables in `dependencies` instead of inline literals.
- [x] 2.4 Convert inline `opts` tables to `opts = function() return { ... } end`, preserving existing option values and config behavior.

## 3. Apply tag pinning and metadata

- [x] 3.1 Select a git tag for each plugin that matches or is closest to the locked commit; if no tag exists, choose the locked commit and note the fallback.
- [x] 3.2 Add `tag = "<tag>"` (or `commit = "<hash>"` fallback) and a comment with tag name, release date, and tag/commit URL above the pin. Reserve `version` for semver/range selectors only.

## 4. Validate and tidy

- [x] 4.1 Confirm the plugin set is unchanged (compare repository list before/after) and that `lazy-lock.json` still resolves.
- [x] 4.2 Run available formatters/checks (e.g., `stylua`, `make validate`, or `nvim --headless` sanity checks) to ensure specs load cleanly.
