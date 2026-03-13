## ADDED Requirements

### Requirement: No textual references to theovim remain (runtime + docs)
The codebase, user-facing documentation, and assets SHALL contain zero textual references to "theovim", its authors, or its repository origins. OpenSpec artifacts are excluded from this check.

#### Scenario: Text scan shows no upstream references
- **WHEN** running a repository-wide search for the case-insensitive term "theovim" across runtime files, documentation, and assets (excluding `openspec/`)
- **THEN** zero matches are found

#### Scenario: Legacy asset removed
- **WHEN** scanning bundled assets for files named or branded "theovim" (e.g., `assets/theovim-banner.jpg`)
- **THEN** no such assets remain referenced or bundled

### Requirement: Identifiers no longer use theovim naming
All identifiers, module names, and file paths derived from theovim naming SHALL be renamed to project-owned equivalents without altering runtime behavior.

#### Scenario: Renamed modules load successfully
- **WHEN** loading the Neovim configuration after renaming any modules or namespaces containing "theovim"
- **THEN** Neovim starts without errors and functionality matches pre-rename behavior

### Requirement: Branding reflects KBroom
User-facing names, commands, messages, and help tags SHALL use the "KBroom" brand with Lua-idiomatic casing.

#### Scenario: Help and documentation rebranded
- **WHEN** opening the bundled help file and README
- **THEN** the help file name and tags are `kbroom*` (e.g., `kbroom.txt`, `kbroom-tldr`), and the README references KBroom with no theovim wording

#### Scenario: Runtime identifiers rebranded
- **WHEN** inspecting augroup names, filetypes, and user-facing echo messages
- **THEN** they use KBroom-branded identifiers (e.g., `KBroomLspConfig`, `kbroomdashboard`, "[KBroom]") and no theovim prefixes

#### Scenario: Mascot and ASCII art updated
- **WHEN** viewing bundled ASCII art in the dashboard or help header
- **THEN** the art references the KBroom mascot Nieve (white labrador, name chosen for “snow” in Spanish) and contains no theovim/Oliver references

### Requirement: No functional dependency on theovim defaults
Runtime behavior SHALL not rely on theovim-specific defaults, plugins, or configuration values.

#### Scenario: Startup without theovim-specific assets
- **WHEN** the configuration is executed on a clean system without any theovim plugins, assets, or default files present
- **THEN** Neovim initializes successfully with equivalent feature set and performance
