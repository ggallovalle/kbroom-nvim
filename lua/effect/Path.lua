---@class effect.Path
---@field service "effect/Path"
---Join path components.
---@field join fun(self: effect.Path, ...: string): string

local Effect = require("effect.Effect")
local key = "effect/Path"

local Service = {
  key = key,
}

---Get the Path service from an effect context
---@param effect Effect<any>
---@return Effect<effect.Path>
function Service.get(effect)
  return Effect.service(effect, key)
end

---Set the Path implementation in an effect context
---@param effect Effect<any>
---@param implementation effect.Path
function Service.set(effect, implementation)
  assert(implementation.service == key)
  effect.context:set(key, implementation)
end

return Service
