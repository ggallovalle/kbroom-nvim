--- init.lua
---
---      \/       \/
---      /\_______/\
---     /   o   o   \
---    (  ==  ^  ==  )
---     )  [Ollie]  (
---    (             )
---    ( (  )   (  ) )
---   (__(__)___(__)__)
---  ___
---   | |_  _  _     o __
---   | | |(/_(_)\_/ | |||
---  Oliver : https://www.asciiart.eu/animals/cats + Jonathan added a few layers of belly because Oliver is a chunky boi
---

vim.g.have_nerd_font = true

require("setup.options").setup()
require("setup.keymap").setup()


-- {{{ commands
--- Trims trailing whitespace
--- \s: white space char, \+ :one or more, $: end of the line, e: suppresses warning when no match found, c: confirm
local function trim_whitespace()
  local win_save = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//ec]])
  vim.fn.winrestview(win_save)
end
vim.api.nvim_create_user_command("TrimWhitespace", trim_whitespace, { nargs = 0 })

-- Changes current working directory
vim.api.nvim_create_user_command("CD", ":lcd %:h", { nargs = 0 })
-- }}}


-- {{{ autocmds
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("TheovimYankHighlight", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
  desc = "Highlight yanked text",
})

-- Switch to insert mode when terminal is open
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  -- TermOpen: for when terminal is opened for the first time
  -- BufEnter: when you navigate to an existing terminal buffer
  group = vim.api.nvim_create_augroup("TheovimTerminal", { clear = true }),
  pattern = "term://*", --> only applicable for "BufEnter", an ignored Lua table key when evaluating TermOpen
  callback = function() vim.cmd("startinsert") end
})

-- Update indentation guide dynamically
local update_leadmultispace_group = vim.api.nvim_create_augroup("UpdateLeadmultispace", { clear = true })

--- Dynamically adjust `leadmultispace` in `listchars` (buffer level) based on `shiftwidth`
local function update_leadmultispace()
  local lead = "┊"
  for _ = 1, vim.bo.shiftwidth - 1 do
    lead = lead .. " "
  end
  vim.opt_local.listchars:append({ leadmultispace = lead })
end

-- When `shiftwidth` was manually changed
vim.api.nvim_create_autocmd("OptionSet", {
  group = update_leadmultispace_group,
  pattern = { "shiftwidth", "filetype" },
  callback = update_leadmultispace,
})

-- When shiftwidth was changed by ftplugin
vim.api.nvim_create_autocmd("BufEnter", {
  group = update_leadmultispace_group,
  pattern = "*",
  callback = update_leadmultispace,
  once = true,
})
-- }}}


-- {{{ netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 0    --> 0: Simple, 1: Detailed, 2: Thick, 3: Tree
vim.g.netrw_browse_split = 3 --> Open file in 0: Reuse the same win, 1: Horizontal split, 2: Vertical split, 3: New tab
vim.g.netrw_winsize = 25     --> seems to be in percentage

vim.g.is_netrw_open = false
--- Toggles netrw
--- Requires vim.g.is_netrw_open global variable to function properly
local function toggle_netrw()
  local fn = vim.fn
  if vim.g.is_netrw_open then
    for i = 1, fn.bufnr("$") do
      if fn.getbufvar(i, "&filetype") == "netrw" then
        vim.cmd("bwipeout " .. i)
      end
    end
    vim.g.is_netrw_open = false
  else
    vim.cmd("Lex")
    vim.g.is_netrw_open = true
  end
end
vim.keymap.set("n", "<leader>n", toggle_netrw,
  { silent = true, noremap = true, desc = "Toggle [N]etrw" })
-- }}}


-- {{{ diagnostic
-- Diagnostic appearance
vim.diagnostic.config({
  float = {
    border = "rounded",
    format = function(diagnostic)
      -- "ERROR (line n): message"
      return string.format("%s (line %i): %s",
        vim.diagnostic.severity[diagnostic.severity],
        diagnostic.lnum + 1,
        diagnostic.message)
    end
  },
  update_in_insert = false,
})

-- Keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
-- }}}


-- {{{ lazy.nvim
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      --{ "\nPress any key to exit..." },
    }, true, {})
    --vim.fn.getchar()
    --os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Either pass the table (containing the plugin info) or string (a directory containing Lua modules)
-- Following will import all Lua files in lua/plugins
require("lazy").setup("plugins")
-- }}}

-- {{{ UI module calls
require("ui.statusline").setup()
require("ui.tabline").setup()
require("ui.dashboard").setup()
-- }}}

-- {{{ Neovide settings
if vim.g.neovide then
  local padding = 10
  vim.g.neovide_padding_top = padding
  vim.g.neovide_padding_bottom = padding
  vim.g.neovide_padding_right = padding
  vim.g.neovide_padding_left = padding

  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_cursor_vfx_mode = "railgun"

  vim.g.neovide_transparency = 0.69
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
end
-- }}}

-- vim: foldmethod=marker
