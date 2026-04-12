---@type effect.XdgDirs
local M = {
  service = "effect/XdgDirs",
  data = function(_self)
    return vim.fn.stdpath("data")
  end,
  config = function(_self)
    return vim.fn.stdpath("config")
  end,
}

return M
