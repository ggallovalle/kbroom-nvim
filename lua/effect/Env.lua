---@class effect.Env
---@field service "effect/Env"
---@field get fun(self: effect.Env, key: string): string
---@field set fun(self: effect.Env, key: string, value: string)

local Effect = require("effect.Effect")
local key = "effect/Env"

local Service = {
  key = key,
}

---Get the Env service from an effect context
---@param effect Effect<any>
---@return Effect<effect.Env>
function Service.get(effect)
  return Effect.service(effect, key)
end

---Set the Env implementation in an effect context
---@param effect Effect<any>
---@param implementation effect.Env
function Service.set(effect, implementation)
  assert(implementation.service == key)
  effect.context:set(key, implementation)
end

return Service
