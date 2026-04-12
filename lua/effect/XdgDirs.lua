---@class effect.XdgDirs
---@field service "effect/XdgDirs"
---@field data fun(self: effect.XdgDirs): string
---@field config fun(self: effect.XdgDirs): string

local Effect = require("effect.Effect")
local key = "effect/XdgDirs"

local Service = {
  key = key,
}

---Get the XdgDirs service from an effect context
---@param effect Effect<any>
---@return Effect<effect.XdgDirs>
function Service.get(effect)
  return Effect.service(effect, key)
end

---Set the XdgDirs implementation in an effect context
---@param effect Effect<any>
---@param implementation effect.XdgDirs
function Service.set(effect, implementation)
  assert(implementation.service == key)
  effect.context:set(key, implementation)
end

return Service
