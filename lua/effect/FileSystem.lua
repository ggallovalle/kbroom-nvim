---@class effect.FileSystem
---@field service "effect/FileSystem"
---Write a string to a file at `path`.
---@field write_file_string fun(self: effect.FileSystem, path: string, content: string, callback: fun(err: string|nil, bytes: integer|nil))
---Check if a path exists.
---@field exist fun(self: effect.FileSystem, path: string, callback: fun(exists: boolean))

local Effect = require("effect.Effect")
local key = "effect/FileSystem"

local Service = {
  key = key
}

---Get the FileSystem service from an effect context
---@param effect Effect<any>
---@return Effect<effect.FileSystem>
function Service.get(effect)
    return Effect.succeed(effect.context:get(key))
end

---Set the FileSystem implementation in an effect context
---@param effect Effect<any>
---@param implementation effect.FileSystem
function Service.set(effect, implementation)
  assert(implementation.service == key)
  effect.context:set(key, implementation)
end

return Service
