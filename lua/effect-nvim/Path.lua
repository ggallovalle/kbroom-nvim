---@type effect.Path
local M = {
  service = "effect/Path",
  join = function(_self, ...)
    return vim.fs.joinpath(...)
  end,
}

return M
