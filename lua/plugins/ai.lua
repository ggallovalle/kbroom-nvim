---@type LazyPluginSpec[]
local plugins = {}

---@type LazyPluginSpec
local Plenary = {
  url = "https://github.com/nvim-lua/plenary.nvim.git",
  -- commit b9fd522 (date unknown, from lazy-lock) https://github.com/nvim-lua/plenary.nvim/commit/b9fd5226c2f76c951fc8ed5923d85e4de065e509
  commit = "b9fd5226c2f76c951fc8ed5923d85e4de065e509",
}

---@type LazyPluginSpec
local CopilotVim = {
  url = "https://github.com/github/copilot.vim.git",
  -- tag v1.58.0 (2025-12-24) https://github.com/github/copilot.vim/releases/tag/v1.58.0
  tag = "v1.58.0",
}

---@type LazyPluginSpec
local CopilotChat = {
  url = "https://github.com/CopilotC-Nvim/CopilotChat.nvim.git",
  -- tag v4.7.4 (2025-10-01) https://github.com/CopilotC-Nvim/CopilotChat.nvim/releases/tag/v4.7.4
  tag = "v4.7.4",
  dependencies = {
    CopilotVim,                      -- copilot core
    Plenary,                         -- curl/log/async helpers
  },
  build = "make tiktoken",           -- Only on MacOS or Linux
  opts = function()
    return {
      window = {
        layout = 'vertical',
        width = 0.3,
        height = 0.5,
        relative = 'editor',
        border = 'single',
        row = nil,
        col = nil,
        title = 'Copilot Chat',
        footer = nil,
        zindex = 1,
      },
    }
  end,
}

plugins[#plugins + 1] = CopilotVim
plugins[#plugins + 1] = CopilotChat

return plugins
