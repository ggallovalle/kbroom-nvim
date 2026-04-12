---@class effect.Path
---@field service "effect/Path"
---Join path components.
---@field join fun(self: effect.Path, ...: string): string

local Effect = require("effect.Effect")

---@type ServiceModule<effect.Path>
local Service = Effect.Service("effect/Path")

return Service
