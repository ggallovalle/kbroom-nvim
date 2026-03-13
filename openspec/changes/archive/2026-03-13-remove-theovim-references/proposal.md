## Why

The current Neovim config still contains code comments, file names, and documentation inherited from the original theovim setup, which causes confusion about ownership, hinders maintainability, and can raise licensing/attribution concerns. Cleaning these traces now prevents future compliance and branding issues as we evolve the config independently.

## What Changes

- Remove all code comments, README text, and metadata that reference theovim or its authorship.
- Rename or refactor any modules, variables, or plugin namespaces that include "theovim" in identifiers or paths.
- Replace upstream-specific configuration defaults with project-owned equivalents so no behavior depends on theovim conventions.
- Audit plugin lockfiles and package metadata to ensure no theovim URLs, names, or credits remain.
- Add an internal note documenting the audit completion and rationale for removing upstream attribution.

## Capabilities

### New Capabilities
- `theovim-removal`: Ensures the codebase, docs, and metadata contain no textual or functional references to the original theovim implementation, establishing a clean, self-owned baseline.

### Modified Capabilities
- `<none>`: No existing capabilities change at the requirements level; this work is a removal/sanitization effort.

## Impact

- Affects Lua configuration modules, plugin setup files, and any shared utilities derived from theovim.
- Impacts documentation (README, changelog, comments) and metadata files (lockfiles, package manifests) where upstream attribution may appear.
- Downstream users may see minor naming changes but no intended functional regressions; tests/health checks should confirm parity after the cleanup.
