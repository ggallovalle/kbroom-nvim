---@type effect.Env
local M = {
  service = "effect/Env",
  get = function(_self, key)
    return vim.env[key]
  end,
  set = function(_self, key, value)
    vim.env[key] = value
  end,
}

return M
