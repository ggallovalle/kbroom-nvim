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
  -- last version check: 2025-03-15
  -- commit date: 2025-06-26
  commit = "d3890fc3cdf0859845a86b2be306bba01458df1a",
  opts = function()
    --- @type NeogitConfig
    return {
      integrations = {
        telescope = true,
      },
    }
  end,
  cmd = "Neogit",
}

return {
  GitSigns,
  NeoGit,
}
