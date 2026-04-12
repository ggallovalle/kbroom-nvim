---@class effect.FileSystem
---@field service "effect/FileSystem"
---Write a string to a file at `path`.
---@field write_file_string fun(self: effect.FileSystem, path: string, content: string): Effect<integer>
---Check if a path exists.
---@field exist fun(self: effect.FileSystem, path: string): Effect<boolean>

local Effect = require("effect.Effect")

---@type ServiceModule<effect.FileSystem>
local Service = Effect.Service("effect/FileSystem")

return Service
