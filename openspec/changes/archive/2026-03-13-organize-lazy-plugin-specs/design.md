## Context

Neovim uses lazy.nvim with plugin specs spread across `lua/plugins/**`. Specs currently mix shorthand repo notation, inline opts tables, and lack `LazyPluginSpec` type annotations. Plugins are mostly pinned via `lazy-lock.json` commits but not tagged or documented, making provenance and reviews harder. `lua/plugins/colorscheme.lua` already returns a single typed spec; the rest need to follow a similar, consistent pattern.

## Goals / Non-Goals

**Goals:**
- Normalize all lazy plugin specs to a consistent style: full git URLs, typed tables, and function-form opts.
- Pin every plugin using lazy.nvim's `tag` field (or `commit` fallback) and document tag metadata (release date + tag/commit URL) adjacent to the pin.
- Keep the plugin set identical while improving readability and reproducibility.
- Standardize structure for complex specs: named, typed tables for the main plugin **and** each dependency; modules always return a `LazyPluginSpec[]` list (even when length 1) to allow growth without reshaping.

**Non-Goals:**
- Adding/removing/replacing plugins.
- Changing plugin configuration behavior beyond reshaping opts wrappers.
- Reworking lazy.nvim loading semantics (events/ft/etc) except as needed for formatting/type clarity.

## Decisions

- **Source notation**: Replace shorthand `"owner/repo"` with full `"https://github.com/owner/repo.git"` in each spec for clarity and grepability.
- **Version pinning**: Prefer the latest stable tag per plugin; if absent, use the tag closest to current locked commit. Record the chosen tag in `tag = "<tag>"` (or `commit` when tags are unavailable). Keep `version` for semver ranges only. Add a preceding comment noting tag name, release date, and tag/commit URL.
- **Type hints**: Annotate every exported plugin table with `---@type LazyPluginSpec` (or `LazyPluginSpec[]` when returning a list). Keep one spec per file when practical; where multiple specs share a file, type each table.
- **Opts shape**: Convert inline opts tables to `opts = function() return { ... } end` to allow lazy computation and future logic while keeping existing option values unchanged.
- **File organization**: Conform to the `lua/plugins/colorscheme.lua` pattern but return a list even for single-spec files. Reorder fields within specs consistently: `---@type`, repo, `tag/commit`, `dependencies`, `opts`, `config`, events/keys, etc.
- **Dependency expression**: Define each dependency as its own named, typed table that follows the same pinning/type/opts patterns as primary specs; include those tables in the `dependencies` list rather than ad-hoc literals. Keep helper functions co-located within the spec file (no extra modules required) to match the existing per-area split (ai/lsp/ui/cmp/etc.).
- **Metadata gathering**: Derive tag dates/URLs from GitHub releases/tags (preferred) or `git ls-remote --tags` as fallback. If network access fails, use existing `lazy-lock.json` commit hashes and mark date as “unknown (locked commit)” to maintain forward progress.

## Risks / Trade-offs

- **Tag availability** → Some plugins may lack suitable tags; fallback to commit hashes reduces clarity but preserves reproducibility.
- **Network reliance** → Fetching tag metadata depends on GitHub; mitigated by offline fallback to `lazy-lock.json` data.
- **Drift during refactor** → Accidental behavior changes while wrapping opts/config; mitigated by keeping diffs minimal and running existing tests/checks (e.g., `make validate` or `nvim --headless` health if available).
