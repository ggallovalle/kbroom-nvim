---@type LazyPluginSpec[]
local plugins = {}

---@type LazyPluginSpec
local Plenary = {
  url = "https://github.com/nvim-lua/plenary.nvim.git",
  -- commit b9fd522 (date unknown, from lazy-lock) https://github.com/nvim-lua/plenary.nvim/commit/b9fd5226c2f76c951fc8ed5923d85e4de065e509
  commit = "b9fd5226c2f76c951fc8ed5923d85e4de065e509",
}

---@type LazyPluginSpec
local TodoComments = {
  url = "https://github.com/folke/todo-comments.nvim.git",
  -- commit 31e3c38 (date unknown, from lazy-lock) https://github.com/folke/todo-comments.nvim/commit/31e3c38ce9b29781e4422fc0322eb0a21f4e8668
  commit = "31e3c38ce9b29781e4422fc0322eb0a21f4e8668",
  event = "VimEnter",
  dependencies = { Plenary },
  opts = function()
    return { signs = false }
  end,
  config = function(_, opts)
    local todo = require("todo-comments")
    todo.setup(opts)
    vim.keymap.set("n", "]t", function() todo.jump_next() end, { desc = "Next todo comment" })
    vim.keymap.set("n", "[t", function() todo.jump_prev() end, { desc = "Previous todo comment" })
  end,
}

---@type LazyPluginSpec
local TsComments = {
  url = "https://github.com/folke/ts-comments.nvim.git",
  -- commit 123a9fb (date unknown, from lazy-lock) https://github.com/folke/ts-comments.nvim/commit/123a9fb12e7229342f807ec9e6de478b1102b041
  commit = "123a9fb12e7229342f807ec9e6de478b1102b041",
  event = "VeryLazy",
  enabled = vim.fn.has("nvim-0.10.0") == 1,
  opts = function()
    return {}
  end,
}

plugins[#plugins + 1] = TodoComments
plugins[#plugins + 1] = TsComments

return plugins
