---@class effect.FileSystem
---@field service "effect/FileSystem"
---Write a string to a file at `path`.
---@field write_file_string fun(self: effect.FileSystem, path: string, content: string, callback: fun(err: string|nil, bytes: integer|nil))
---Check if a path exists.
---@field exist fun(self: effect.FileSystem, path: string, callback: fun(exists: boolean))

local key = "effect/FileSystem"

local Service = {
    key = key
}

---@param effect effect.Effect
---@param callback fun(fs: effect.FileSystem)
Service.get = function(effect, callback)
    return effect:get(key, callback)
end

---@param effect any
---@param implementation any
Service.set = function(effect, implementation)
    assert(implementation.service == key)
    effect:set(key, implementation)
end

return Service
