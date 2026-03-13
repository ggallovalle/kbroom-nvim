## Context

The Neovim configuration originated from theovim and still contains visible traces: namespaced modules, comments, README text, and possible lockfile metadata. These traces cause ownership confusion and potential licensing/attribution obligations. The codebase is Lua-based with plugins managed via the chosen plugin manager (e.g., lazy.nvim) and relies on startup health checks.

## Goals / Non-Goals

**Goals:**
- Remove all textual references to theovim across code, docs, comments, and metadata.
- Rename identifiers, modules, and namespaces that include "theovim" while preserving behavior.
- Eliminate functional dependence on theovim-specific defaults, plugins, or assets.
- Provide a repeatable audit approach to confirm the cleanup.

**Non-Goals:**
- Introduce new features or refactor unrelated configuration structure.
- Change plugin selections beyond replacing theovim-specific artifacts when necessary.
- Rewrite the config philosophy; focus is on attribution/identity cleanup.

## Decisions

- **Search & audit tooling:** Use `rg -i "theovim"` across the repo to locate any textual references, including comments, docs, lockfiles, and plugin metadata. Rationale: fast, repeatable, CI-friendly.
- **Brand naming:** Use the "KBroom" brand in user-facing text; Lua identifiers use idiomatic casing (augroup names `KBroom*`, filetypes lowercase like `kbroomdashboard`, variables `kbroom_*`). Rationale: consistent brand and Lua style.
- **Help/doc rename:** Keep the help doc but rename to `kbroom.txt` with `kbroom*` tags; update README references accordingly. Rationale: preserve docs while rebranding.
- **Mascot/art:** Replace theovim/Oliver cat ASCII art with KBroom's mascot Nieve (white labrador; name chosen for “snow”) in help headers and dashboard art. Rationale: align visuals with new ownership/identity.
- **Identifier renaming approach:** Prefer Lua module/namespace renames with `sed` or editor-assisted refactors, then run Neovim startup to verify no broken `require` paths. Rationale: minimizes manual miss cases while ensuring runtime validation.
- **Plugin/source provenance:** Replace any theovim-specific plugin forks or URLs with canonical upstreams or project-owned mirrors. Rationale: removes hidden upstream dependencies while keeping functionality.
- **Documentation stance:** Update README/changelog to describe the config as project-owned KBroom; remove theovim references and the theovim-branded banner asset without adding a replacement unless an existing KBroom asset already exists. Rationale: aligns ownership, avoids broken links.
- **Verification:** Add a short internal note (or checklist entry) recording date, scope, and command used for the audit. Rationale: future maintainers can rerun and confirm cleanliness.

## Risks / Trade-offs

- [Broken module paths] → Mitigate by running Neovim startup/tests after each rename and searching for `module not found` errors.
- [Hidden binary/assets references] → Mitigate by scanning plugin specs and lockfiles; if uncertain, delete and regenerate lockfiles.
- [Regressions from default changes] → Mitigate by snapshotting key behaviors (LSP, Treesitter, theme) before cleanup and retesting after.
- [Compliance expectations] → Mitigate by keeping a brief internal audit note describing the cleanup commands and results.

## Migration Plan

1) Run `rg -i "theovim"` to gather all locations; capture list for traceability.
2) Rename modules/files/namespaces containing "theovim"; update corresponding `require` calls and plugin specs.
3) Remove or rewrite comments, README sections, and metadata entries referencing theovim; regenerate lockfiles if they embed upstream URLs.
4) Replace any theovim-specific plugin sources with upstream equivalents; reinstall plugins to confirm.
5) Run Neovim startup/tests (including `:checkhealth` if available) to ensure parity.
6) Record the audit command and date in an internal note (non-user-facing) to document completion.

## Open Questions

- Which plugin manager is in use (e.g., lazy.nvim vs packer) to tailor lockfile regeneration steps?
- Are there automated tests or CI checks we should run beyond manual startup (e.g., headless Neovim smoke test script)?
