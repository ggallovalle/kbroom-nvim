--- plugins/treesitter.lua
--- Configure Neovim built-in Treesitter engine

---@type LazyPluginSpec[]
local plugins = {
  {
    url = "https://github.com/nvim-treesitter/nvim-treesitter.git",
    -- commit 42fc28b (date unknown, from lazy-lock) https://github.com/nvim-treesitter/nvim-treesitter/commit/42fc28ba918343ebfd5565147a42a26580579482
    commit = "42fc28ba918343ebfd5565147a42a26580579482",
    build = ":TSUpdate",
    opts = function()
      return {
        ensure_installed = { "bash", "c", "cpp", "latex", "lua", "markdown", "python" },
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<C-s>",
            node_decremental = "<M-space>",
          },
        },
      }
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}

return plugins
