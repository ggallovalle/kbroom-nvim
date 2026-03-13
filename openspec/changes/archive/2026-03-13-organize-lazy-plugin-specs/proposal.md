## Why

The current lazy.nvim plugin specs are inconsistent (mixed shorthand vs full URLs, inline opts, and missing type hints) and unpinned, making reviews harder and reproducibility fragile.

## What Changes

- Rewrite every lazy.nvim plugin spec to use full Git URLs instead of the shorthand owner/repo form.
- Pin each plugin to a specific git tag; annotate the spec with the tag’s release date and a tag/commit URL for quick auditing.
- Add `LazyPluginSpec` annotations to every exported plugin table, mirroring the pattern used in `lua/plugins/colorscheme.lua` even for single-plugin files.
- Prefer `opts = function() return { ... } end` style over inline tables for plugin options for consistency and future extension.
- Preserve the existing plugin set (no additions or removals) while reorganizing definitions for clearer structure and reviewability.

## Capabilities

### New Capabilities
- `lazy-plugin-style-guide`: Defines uniform formatting, typing, and option patterns for all lazy.nvim plugin specs.
- `lazy-plugin-pinning`: Establishes mandatory tag pinning with human-readable metadata (tag date and URL) across all plugins.

### Modified Capabilities
- None.

## Impact

- Affects lazy.nvim spec files under `lua/plugins/**`, ensuring consistent structure and typing.
- Introduces tag metadata requirements that may involve fetching release/tag info once per plugin.
- Downstream tasks must avoid changing the plugin list or functionality while refactoring for style and pinning.
