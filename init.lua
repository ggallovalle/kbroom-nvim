--- init.lua

vim.g.have_nerd_font = true

require("setup.options").setup()
require("setup.keymap").setup()
require("setup.user_command").setup()
require("setup.autocmd").setup()
require("setup.netrw").setup()
require("setup.diagnostic").setup()
require("setup.lazy_nvim").setup()

-- {{{ UI module calls
require("ui.statusline").setup()
require("ui.tabline").setup()
require("ui.dashboard").setup()
-- }}}

require("setup.neovide").setup()
require("globals")

-- vim: foldmethod=marker

