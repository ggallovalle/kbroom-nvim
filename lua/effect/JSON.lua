---@class effect.JSON
---@field service "effect/JSON"
---Decode a JSON string to a Lua value.
---@field decode fun(self: effect.JSON, json: string): Effect<any>
---Encode a Lua value to a JSON string.
---@field encode fun(self: effect.JSON, value: any): Effect<string>

local Effect = require("effect.Effect")

---@type ServiceModule<effect.JSON>
local Service = Effect.Service("effect/JSON")

return Service
