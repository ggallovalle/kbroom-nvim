---@type LazyPluginSpec[]
local plugins = {}

---@type LazyPluginSpec
local Telescope = {
  url = "https://github.com/nvim-telescope/telescope.nvim.git",
  -- commit a0bbec2 (date unknown, from lazy-lock) https://github.com/nvim-telescope/telescope.nvim/commit/a0bbec21143c7bc5f8bb02e0005fa0b982edc026
  commit = "a0bbec21143c7bc5f8bb02e0005fa0b982edc026",
}

---@type LazyPluginSpec
local GitSigns = {
  url = "https://github.com/lewis6991/gitsigns.nvim.git",
  -- commit 1ce96a4 (date unknown, from lazy-lock) https://github.com/lewis6991/gitsigns.nvim/commit/1ce96a464fdbc24208e24c117e2021794259005d
  commit = "1ce96a464fdbc24208e24c117e2021794259005d",
  opts = function()
    return {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        vim.keymap.set(
          "n",
          "<leader>gd",
          require("gitsigns").diffthis,
          { buffer = bufnr, desc = "[G]it [D]iff current buffer" }
        )
      end,
    }
  end,
}

---@type LazyPluginSpec
local NeoGit = {
  url = "https://github.com/NeogitOrg/neogit.git",
  -- tag v1.0.0 (2024-05-16) https://github.com/NeogitOrg/neogit/releases/tag/v1.0.0
  tag = "v1.0.0",
  name = "neogit",
  main = "neogit",
  dependencies = { Telescope },
  opts = function()
    return {
      integrations = {
        telescope = true,
      },
    }
  end,
}

plugins[#plugins + 1] = GitSigns
plugins[#plugins + 1] = NeoGit

return plugins
