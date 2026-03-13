## 1. Audit current references

- [x] 1.1 Run `rg -i "theovim"` across repo and capture all hit locations
- [x] 1.2 Classify hits by type (code identifiers, comments/docs, metadata/lockfiles)

## 2. Rename code and modules

- [x] 2.1 Rename any Lua modules, namespaces, or variables containing "theovim" to project-owned names and update all `require` calls
- [x] 2.2 Replace theovim-specific plugin sources or forks with upstream/project-owned equivalents; reinstall plugins
- [x] 2.3 Remove any reliance on theovim default config values; set explicit project defaults

## 3. Clean docs and metadata

- [x] 3.1 Rewrite README/changelog sections to remove theovim attribution and describe project ownership
- [x] 3.2 Strip theovim references from comments and inline documentation
- [x] 3.3 Regenerate lockfiles or metadata files to eliminate embedded theovim URLs/names

## 4. Verify and document

- [x] 4.1 Start Neovim and run health/startup checks to confirm no missing modules or regressions
- [x] 4.2 Re-run `rg -i "theovim"` to verify zero matches remain
- [x] 4.3 Add an internal audit note (date, commands used, summary) recording completion of the cleanup
