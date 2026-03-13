---@type LazyPluginSpec[]
local plugins = {
  {
    url = "https://github.com/NvChad/nvim-colorizer.lua.git",
    -- commit 338409d (date unknown, from lazy-lock) https://github.com/NvChad/nvim-colorizer.lua/commit/338409dd8a6ed74767bad3eb5269f1b903ffb3cf
    commit = "338409dd8a6ed74767bad3eb5269f1b903ffb3cf",
    opts = function()
      return {}
    end,
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
  },
}

return plugins
