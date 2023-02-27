--[[
" figlet -f weird theovim-cmd
"  /    /                   /                        |
" (___ (___  ___  ___         _ _  ___  ___  _ _  ___|
" |    |   )|___)|   ) \  )| | | )     |    | | )|   )
" |__  |  / |__  |__/   \/ | |  /      |__  |  / |__/
--]]
--

-- {{{ Update command
vim.api.nvim_create_user_command("TheovimUpdate", function()
  vim.api.nvim_command(":! cd ~/.theovim && ./theovim-util.sh update")
  --vim.notify("Update complete. Use :TheovimInfo command to see the latest changelog")
  require('lazy').sync()
end, { nargs = 0 })
-- }}}

-- {{{ Util commands
-- Reference: https://github.com/ellisonleao/glow.nvim/blob/main/lua/glow/init.lua
local function spawn_floating_win(file_path)
  local width = vim.o.columns
  local height = vim.o.lines
  local height_ratio = 0.8
  local width_ratio = 0.8
  local win_height = math.ceil(height * height_ratio)
  local win_width = math.ceil(width * width_ratio)
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local win_opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    border = "shadow",
  }

  -- create preview buffer and set local options
  local buf = vim.api.nvim_create_buf(false, true) -- Not add to buffer list (false), scratch buffer (true)
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- options
  vim.api.nvim_win_set_option(win, "winblend", 0) --> How much does the background color blends in (80 will be black)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe") --> Kill the buffer when hidden
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

  -- keymaps
  local keymaps_opts = { silent = true, buffer = buf }
  vim.keymap.set('n', "q", "<C-w>q", keymaps_opts)
  vim.keymap.set('n', "<ESC>", function() vim.api.nvim_win_close(win, true) end, keymaps_opts)

  -- https://www.reddit.com/r/neovim/comments/s97tja/opening_an_existing_file_in_a_floating_window/
  vim.api.nvim_buf_set_option(0, "modifiable", true)
  vim.api.nvim_command("$read" .. file_path) -- Is it same as :read command? I'm not sure
  vim.api.nvim_buf_set_option(0, "modifiable", false)
end

local helpdoc_path = vim.api.nvim_get_runtime_file("theovim-docs/theovim-help-doc.md", false)[1]
-- nargs ?: 0 or 1, *: > 0, +: > 1 args
vim.api.nvim_create_user_command("TheovimHelp", function() spawn_floating_win(helpdoc_path) end, { nargs = 0 })

local vimhelp_path = vim.api.nvim_get_runtime_file("theovim-docs/vim-help.md", false)[1]
-- nargs ?: 0 or 1, *: > 0, +: > 1 args
vim.api.nvim_create_user_command("TheovimVanillaVimHelp", function() spawn_floating_win(vimhelp_path) end, { nargs = 0 })

local info_path = vim.api.nvim_get_runtime_file("theovim-docs/theovim-info.md", false)[1]
vim.api.nvim_create_user_command("TheovimInfo", function() spawn_floating_win(info_path) end, { nargs = 0 })
-- }}}

-- {{{ Notepad
-- Inspiration: https://github.com/tamton-aquib/stuff.nvim
NOTEPAD_LOADED = false
local buf, win
local function launch_notepad()
  if not NOTEPAD_LOADED or not vim.api.nvim_win_is_valid(win) then
    if not buf or not vim.api.nvim_buf_is_valid(buf) then
      buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
      vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
      vim.api.nvim_buf_set_lines(buf, 0, 1, false,
        { "WARNING: Notepad content will be erased when the current Neovim instance closes" })
    end
    win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      border = "rounded",
      style = "minimal",
      row = 0,
      col = math.ceil(vim.o.columns / 2),
      height = math.ceil(vim.o.lines / 2),
      width = math.ceil(vim.o.columns / 2)
    })
    local keymaps_opts = { silent = true, buffer = buf }
    vim.keymap.set('n', "<ESC>", function() launch_notepad() end, keymaps_opts)
    vim.keymap.set('n', "q", function() launch_notepad() end, keymaps_opts)
  else
    vim.api.nvim_win_hide(win)
  end
  NOTEPAD_LOADED = not NOTEPAD_LOADED
end

vim.api.nvim_create_user_command("Notepad", launch_notepad, { nargs = 0 })
-- }}}
