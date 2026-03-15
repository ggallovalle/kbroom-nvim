---@type LazyPluginSpec
local Autopairs = {
  url = "https://github.com/windwp/nvim-autopairs.git",
  -- last version check: 2026-03-15
  -- commit date: 2026-01-29
  commit = "59bce2eef357189c3305e25bc6dd2d138c1683f5",
  event = "InsertEnter",
  opts = function()
    return {}
  end,
}

return {
  Autopairs,
}
