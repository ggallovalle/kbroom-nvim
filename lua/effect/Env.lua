---@class effect.Env
---@field service "effect/Env"
---@field get fun(self: effect.Env, key: string): string
---@field set fun(self: effect.Env, key: string, value: string)

local Effect = require("effect.Effect")

---@type ServiceModule<effect.Env>
local Service = Effect.Service("effect/Env")

return Service
