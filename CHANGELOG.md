# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- code organization
  - split setup in `init.lua` into its own files ([#1][i1])
- user interface
  - setup colorschemes
    1. tokyonigth
    2. gruvbox
    3. onedark
    4. nord
    5. catppuccin
    6. vscode
    7. github

## [Template]

Heading format

```
[{{ semantic version }}] - {{ ISO Date }}
```

Examples
```
## [1.1.1] - 2023-03-05
## [2.0.0] - 2024-01-01
```

### Added
for new features.

Item format

```
- {{ scope }}
  - {{ short description }} (#{{issue number}})
```

Examples
- i18n
  - Improve french translations ([#33][i33])

### Changed
for changes in existing functionality

### Deprecated
for soon-to-be removed features

### Removed
for now removed features

### Fixed
for any bug fixes

### Security
in case of vulnerabilities

# Changelog that is not actually a Changelog

Below is the list of options, keybindings, Lua functions, plugins, and other Neovim features I tried that did not work out for me.

## Options

- `autochdir`: I thought it would be helpful for narrowing down the Telescope search scope (e.g., opening `~/code/project/code.lua` from the home directory using Telescope Oldfiles).
    But there were two issues:
    1. It narrowed the scope down even when I did not want to. For example, if I open `lua/plugins/tokyonight.lua` from `nvim` folder, I want the current working directory (CWD) to stay in `nvim` instead of `plugins`.
    2. I often execute a single Python script using `:!python3 %:p`, but if I manually change the CWD using `:cd` or `:lcd`, it behaves really weirdly with `autochdir`
    (`%:p` returns `directory_that_i_manually_cd_to/filename.py` instead of `actual_filepath/filename.py`).
    Instead of `autochdir`, I create a command for `:lcd %:h` to quickly change the CWD.
- `laststatus=3` and Winbar: I manage my own Statusline and Tabline, and I tried moving LSP information to Winbar thinking it would de clutter my Statusline.
    However, I felt like it was taking up one row unnecessarily.
    I referenced Mini.statusline to create active/inactive Statusline as well as simpler Statusline when the window size is small, and I could not be happier.
- `:ShowChanges` (`vim.api.nvim_create_user_command("ShowChanges", ":w !diff % -", { nargs = 0 })`): Vim has a built-in `:changes`, albeit much harder to use

## Keybindings

- `{ noremap = true, silent = true }`: noremap = true` is default in `vim.keymap.set`, is `silent` really necessary?
- `<leader>1-9` to navigate tabs: use `gt`
- `<leader>t` to create a new tab: Create a new split window and break it out to a new tab using `<C-w>T`
- `<leader>+-<>` to resize window by 1/3 of the screen size: I just decided to use a built-in resize binding

## Autocmds

- Autocmd to set indentation settings based on filetype: ftplugin is better!
    ```lua
    -- Dictionary for supported file type (key) and the table containing values (values)
    local ft_style_vals = {
      ["cpp"] = { colorcolumn = "80", tabwidth = 2 },
      ["python"] = { colorcolumn = "80", tabwidth = 4 },
      ["lua"] = { colorcolumn = "120", tabwidth = 2 },
    }
    -- Make an array of the supported file type
    local ft_names = {}
    local n = 0
    for i, _ in pairs(ft_style_vals) do
      n = n + 1
      ft_names[n] = i
    end
    -- Using the array and dictionary, make autocmd for the supported ft
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("FileSettings", { clear = true }),
      pattern = ft_names,
      callback = function()
        vim.opt_local.colorcolumn = ft_style_vals[vim.bo.filetype].colorcolumn
        vim.opt_local.shiftwidth = ft_style_vals[vim.bo.filetype].tabwidth
        vim.opt_local.tabstop = ft_style_vals[vim.bo.filetype].tabwidth
      end
    })
    ```
- Autocmd to automatically close a terminal when the exit code is 0.
    ```lua
    vim.api.nvim_create_autocmd("TermClose", {
      group = term_augroup,
      callback = function()
        if vim.v.event.status == 0 then
          vim.api.nvim_buf_delete(0, {})
          vim.notify_once("Previous terminal job was successful!")
        else
          vim.notify_once("Error code detected in the current terminal job!")
        end
      end
    })
    ```
    The problem was that sometimes you want the window to persist (e.g., `termopen()`) even when the exit code is 0.
    So I had to implement notifications for both cases, which was no better than having the terminal window open.
- Autocmd to import a file template: It was an okay idea, but I did not want to maintain templates.
    If you want to use a template, use `:read /path/to/template`.

## Lua functions

- `:Weather`: You are so extra, Theo.
    ```lua
    -- Simplified version of https://github.com/ellisonleao/weather.nvim
    local function weather_popup(location)
      local win_height = math.ceil(vim.o.lines * 0.6 - 20)
      local win_width = math.ceil(vim.o.columns * 0.3 - 15)
      local x_pos = 1
      local y_pos = vim.o.columns - win_width

      local win_opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = x_pos,
        col = y_pos,
        border = "single",
      }

      local buf = vim.api.nvim_create_buf(false, true)
      local win = vim.api.nvim_open_win(buf, true, win_opts)

      vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
      vim.api.nvim_win_set_option(win, "winblend", 0)

      local keymaps_opts = { silent = true, buffer = buf }
      vim.keymap.set('n', "q", "<C-w>q", keymaps_opts)
      vim.keymap.set('n', "<ESC>", function() vim.api.nvim_win_close(win, true) end, keymaps_opts)

      local weather_command = "curl 'https://wttr.in/?0T' > /dev/null"
      if location ~= nil then
        weather_command = string.format("curl https://wttr.in/%s'?'0T", location.args)
      end
      vim.fn.termopen(weather_command)
    end
    vim.api.nvim_create_user_command("Weather", weather_popup, { nargs = '?' }) --> ?: 0 or 1, *: > 0, +: > 1 args
    ```
- `:TheovimUpdate`: It was a combination of `vim.fn.termopen("cd" .. vim.opt.runtimepath:get()[1] .. " && git pull")`, `:Lazy update`, `:TSUpdate`, and `:MasonUpdate`.
    It was too complex.
- `:TheovimReadme` and other family of displaying a markdown file in a floating window: I wrote 800 lines of help document in Vim's built-in help syntax.
    ```lua
    Util.spawn_floting_doc_win = function(file_path)
      local win_height = vim.api.nvim_win_get_height(0) or vim.o.lines
      local win_width = vim.api.nvim_win_get_width(0) or vim.o.columns
      local float_win_height = math.ceil(win_height * 0.8)
      local float_win_width = math.ceil(win_width * 0.8)
      local x_pos = math.ceil((win_width - float_win_width) * 0.5)   --> Centering the window
      local y_pos = math.ceil((win_height - float_win_height) * 0.5) --> Centering the window

      local win_opts = {
        border = "rounded", --> sigle, double, rounded, solid, shadow
        relative = "editor",
        style = "minimal",  --> No number, cursorline, etc.
        width = float_win_width,
        height = float_win_height,
        row = y_pos,
        col = x_pos,
      }

      local float_win = function()
        -- create preview buffer and set local options
        local buf = vim.api.nvim_create_buf(false, true) --> Not add to buffer list (false), scratch buffer (true)
        local win = vim.api.nvim_open_win(buf, true, win_opts)

        -- options
        vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")    --> Kill the buffer when hidden
        vim.api.nvim_buf_set_option(buf, "filetype", "markdown") --> Markdown syntax highlighting
        vim.opt_local.spell = false                              --> Diable spell check, spell is win option
        vim.api.nvim_win_set_option(win, "winblend", 24)         --> 0 for solid color, 80 for transparent

        -- keymaps
        local keymaps_opts = { silent = true, buffer = buf }
        vim.keymap.set('n', "q", "<C-w>q", keymaps_opts) --> both C-w q or below function are fine
        vim.keymap.set('n', "<ESC>", function() vim.api.nvim_win_close(win, true) end, keymaps_opts)

        -- Reading the file
        vim.api.nvim_buf_set_option(0, "modifiable", true)
        vim.cmd("silent 0r" .. file_path)
        vim.api.nvim_buf_set_option(0, "modifiable", false)
      end
      return float_win
    end

    local readme_path = vim.api.nvim_get_runtime_file("README.md", false)[1]
    local helpdoc_func = Util.spawn_floting_doc_win(readme_path)
    vim.api.nvim_create_user_command("TheovimReadme", helpdoc_func, { nargs = 0 })
    ```
- Simulating `gx` keybinding: It was useful when Netrw was disabled for nvim-tree.
    ```lua
    local function url_handler()
      -- <something>://<something that aren't >,;")>
      local url = string.match(vim.fn.getline("."), "[a-z]*://[^ >,;)\"']*")
      if url ~= nil then
        -- If URL is found, determine the open command to use
        local cmd = nil
        local sysname = vim.loop.os_uname().sysname
        if sysname == "Darwin" then --> or use vim.fn.has("mac" or "linux", etc.)
          cmd = "open"
        elseif sysname == "Linux" then
          cmd = "xdg-open"
        end
        -- Open the URL using exec
        if cmd then
          vim.cmd('exec "!' .. cmd .. " '" .. url .. "'" .. '"') --> exec "!open 'foo://bar baz'"
        end
      else
        vim.notify("No URI found in the current line")
      end
    end
    ```

## Plugins

- **wbthomason/packer.nvim**: I just migrated to lazy.nvim because everyone did.
    Joking, but I migrated to lazy.nvim because of the syntax.
    Passing a Lua table as an argument is clearly better than repeating `use` multiple times.
    I could care less about lazy-loading though, I think it is an overblown concept.
- Single-file Lazy config: splitting them into different Lua module in `lua/plugins` directory allows a better organization

UI:

- **nvim-tree/nvim-tree.lua**:
    - Its role to organize files has been replaced by Oil.nvim
    - Its role to center the text has been replaced by Netrw
- **lukas-reineke/indent-blankline.nvim**: Vim 9 introduced |lcs-leadmultispace|
- **romgrk/barbar.nvim** / **akinsho/bufferline.nvim**: I wrote my own Tabline that also displays number of open buffers.
    That way, I can remember the fact that I opened a file before and use Telescope to switch buffers.
- **folke/zen-mode.nvim**: I appreciate this plugin and somewhat miss it, but most of the time, I just need the text to be in the center of the screen when I am using a wide monitor.
    I solved the problem by simply launching nvim-tree and adjusting its size until the main window is roughly centered.
- **nvimdev/dashboard-nvim**: The author made a [breaking change](https://github.com/nvimdev/dashboard-nvim/commit/12383a503e961d3a9fecc6f21c972322db794962) without a backward compatibility.
    There is nothing wrong with it, but the Dashboard looked uglier after the update.
    It also cached the Dashboard string as a text file to advertise the low memory usage, which I thought was very unnecessary.
    Instead, I wrote my own startup Dashboard.

LSP:

- **nvimdev/lspsaga.nvim**: It is an LSP UI wrapper + collection of LSP tools, and I did not like having one plugin that tried to do everything.
    "Breadcrumbs" (Winbar symbol feature) feature actually broke once when I changed a colorscheme and highlight groups reset, and I had a hard time debugging where the source of errors was because I did not even know that the feature was added to the plugin.
    It was a wake up call for me to prefer one plugin that does one thing and one thing well.
    Features I occasionally miss are:
    - "Breadcrumbs": Symbols in the Winbar
    - "Outline": IDE like symbol outline
- **hrsh7th/cmp-nvim-lua**: Completion source for Neovim API, replaced by neodev plugin.

## File Organization

- Cloning config as `~/.theovim` and creating symlink at `~/.config/nvim`: It was as stupid as it sounds
- Uploading binary files (images) to the repository: Git is a **version control system**!!
    At one point, my repository grew up to 14MB when it is just ~2000 lines of Lua code and plain text files.
    Follow GitHub guide on [Removing sensitive data from a repository](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository) to remove large files.


[i1]: https://github.com/ggallovalle/kbroom-nvim/issues/1
[i33]: https://github.com/ggallovalle/kbroom-nvim/issues/33
