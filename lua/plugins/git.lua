local GitSigns = {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
      vim.keymap.set("n", "<leader>gd", require("gitsigns").diffthis,
        { buffer = bufnr, desc = "[G]it [D]iff current buffer" })
    end
  },
}

local NeoGit = {
  url = "https://github.com/NeogitOrg/neogit",
  -- 2024-05-16
  tag = "v1.0.0",
  name = "neogit",
  main = "neogit",
  dependencies = {
    "nvim-telescope/telescope.nvim", 
  },
  opts = {
    integrations = {
      telescope = true
    }
  },
}

return {
  GitSigns,
  NeoGit
}
