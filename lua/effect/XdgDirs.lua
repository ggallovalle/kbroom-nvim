---@class effect.XdgDirs
---@field data fun(self: effect.XdgDirs): string
---@field config fun(self: effect.XdgDirs): string

local Effect = require("effect.Effect")

---@type ServiceModule<effect.XdgDirs>
local Service = Effect.Service("effect/XdgDirs")

return Service
