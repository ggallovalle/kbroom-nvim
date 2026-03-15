---@type LazyPluginSpec
local NvimColorizer = {
  url = "https://github.com/NvChad/nvim-colorizer.lua.git",
  -- last version check: 2026-03-15
  -- commit date: 2026-03-07
  commit = "ef211089af881bea206c7aa3f2693a81feee7e90",
  event = "BufReadPre",
  opts = function()
    return {}
  end,
}

return {
  NvimColorizer,
}
