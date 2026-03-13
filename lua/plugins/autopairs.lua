---@type LazyPluginSpec[]
local plugins = {
  {
    url = "https://github.com/windwp/nvim-autopairs.git",
    -- commit 59bce2e (date unknown, from lazy-lock) https://github.com/windwp/nvim-autopairs/commit/59bce2eef357189c3305e25bc6dd2d138c1683f5
    commit = "59bce2eef357189c3305e25bc6dd2d138c1683f5",
    opts = function()
      return {}
    end,
  },
}

return plugins
