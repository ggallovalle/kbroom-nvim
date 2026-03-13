---@type LazyPluginSpec[]
local plugins = {
  {
    url = "https://github.com/slembcke/debugger.lua.git",
    -- commit 6e2fac8 (date unknown, from lazy-lock) https://github.com/slembcke/debugger.lua/commit/6e2fac8daa33afbad3d59f7494ff5d851c85304a
    commit = "6e2fac8daa33afbad3d59f7494ff5d851c85304a",
    opts = function()
      return {}
    end,
  },
}

return plugins
