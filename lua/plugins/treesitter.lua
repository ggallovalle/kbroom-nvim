---@type LazyPluginSpec
local Treesitter = {
  url = "https://github.com/nvim-treesitter/nvim-treesitter.git",
  -- last version check: 2026-03-15
  -- commit date: 2026-03-14
  commit = "f873ec2955098fc4b7c3abfe891bdd49fa7947e2",
  build = ":TSUpdate",
  lazy = false,
  config = function(self, opts)
    require("nvim-treesitter").setup()
    require("nvim-treesitter").install({
      -- general
      "markdown",
      "markdown_inline",
      "gitignore",
      "sql",
      --
      "rust",
      --
      "lua",
      --
      "python",
      -- javascript and web
      "javascript",
      "typescript",
      "jsx",
      "tsx",
      "vue",
      "css",
      "html",
      -- elixir
      "elixir",
      "eex",
      -- data transport
      "json",
      "kdl",
      "yaml",
      "xml",
      "csv",
      "toml",
      "hcl",
      -- terminal
      "bash",
      "fish",
      "zsh",
      "powershell",
      "dockerfile",
      "just",
    })
  end,
}

return {
  Treesitter,
}
