local Effect = require("effect.Effect")

---@type effect.JSON
local M = {
  service = "effect/JSON",
  decode = function(_self, json)
    return Effect.sync(function()
      return vim.fn.json_decode(json)
    end)
  end,
  encode = function(_self, value)
    return Effect.sync(function()
      return vim.fn.json_encode(value)
    end)
  end,
}

return M
