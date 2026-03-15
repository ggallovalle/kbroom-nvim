local settings = require("settings")

---@type LazyPluginSpec
local CopilotVim = {
  url = "https://github.com/github/copilot.vim.git",
  -- tag v1.58.0 (2025-12-24) https://github.com/github/copilot.vim/releases/tag/v1.58.0
  tag = "v1.58.0",
  cond = function()
    return settings.enable_ai
  end,
}

---@type LazyPluginSpec
local CopilotChat = {
  url = "https://github.com/CopilotC-Nvim/CopilotChat.nvim.git",
  -- tag v4.7.4 (2025-10-01) https://github.com/CopilotC-Nvim/CopilotChat.nvim/releases/tag/v4.7.4
  tag = "v4.7.4",
  cond = function()
    return settings.enable_ai
  end,
  dependencies = {
    CopilotVim, -- copilot core
  },
  build = "make tiktoken", -- Only on MacOS or Linux
  opts = function()
    return {
      window = {
        layout = "vertical",
        width = 0.3,
        height = 0.5,
        relative = "editor",
        border = "single",
        row = nil,
        col = nil,
        title = "Copilot Chat",
        footer = nil,
        zindex = 1,
      },
    }
  end,
}

return {
  CopilotVim,
  CopilotChat,
}
