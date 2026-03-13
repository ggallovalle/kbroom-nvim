---@type LazyPluginSpec[]
local plugins = {
  {
    url = "https://github.com/lervag/vimtex.git",
    -- commit f707368 (date unknown, from lazy-lock) https://github.com/lervag/vimtex/commit/f707368022cdb851716be0d2970b90599c84a6a6
    commit = "f707368022cdb851716be0d2970b90599c84a6a6",
    ft = { "plaintex", "tex" },
    config = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "skim" --> macOS
      -- vim.g.vimtex_view_method = "zathura" --> Linux
    end,
  },
}

return plugins
