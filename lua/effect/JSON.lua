---@class effect.JSON
---@field service "effect/JSON"
---Decode a JSON string to a Lua value.
---@field decode fun(self: effect.JSON, json: string): Effect<any>
---Encode a Lua value to a JSON string.
---@field encode fun(self: effect.JSON, value: any): Effect<string>

local Effect = require("effect.Effect")
local key = "effect/JSON"

local Service = {
  key = key,
}

---Get the JSON service from an effect context
---@param effect Effect<any>
---@return Effect<effect.JSON>
function Service.get(effect)
  return Effect.service(effect, key)
end

---Set the JSON implementation in an effect context
---@param effect Effect<any>
---@param implementation effect.JSON
function Service.set(effect, implementation)
  assert(implementation.service == key)
  effect.context:set(key, implementation)
end

return Service
