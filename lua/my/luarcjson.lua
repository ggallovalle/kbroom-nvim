local Effect = require("effect.Effect")
local Env = require("effect.Env")
local FileSystem = require("effect.FileSystem")
local JSON = require("effect.JSON")
local Path = require("effect.Path")
local XdgDirs = require("effect.XdgDirs")

local M = {}

---@param path effect.Path
---@param xdg effect.XdgDirs
---@param env effect.Env
---@return table
function M.luarc(path, xdg, env)
    local data_path = xdg:data()

    local luarc = {
        runtime = {
            version = "LuaJIT",
            path = {
                "lua/?.lua",
                "lua/?/init.lua",
            },
        },
        workspace = {
            checkThirdParty = false,
            library = {
                env:get("VIMRUNTIME"),
                path:join(data_path, "lazy"),
            },
        },
    }
    return luarc
end

---@class my.luarcjson.write_luarc_json_Result
---@field path string
---@field saved "yes" | "no-already-exists"

---@param result my.luarcjson.write_luarc_json_Result
---@return my.luarcjson.write_luarc_json_Result
local function write_luarc_json_result(result)
    return result
end

---Write .luarc.json to nvim config directory
---@param effect Effect<any>
---@return Effect<{path: string, saved: "yes" | "no-already-exists"}>
function M.write_luarc_json(effect)
    return Effect.gen(function()
        local xdg = Effect.yield(XdgDirs.get(effect))
        local path_svc = Effect.yield(Path.get(effect))
        local json = Effect.yield(JSON.get(effect))
        local env = Effect.yield(Env.get(effect))
        local fs = Effect.yield(FileSystem.get(effect))

        local config_path = path_svc:join(xdg:config(), ".luarc.json")
        local luarc = M.luarc(path_svc, xdg, env)
        local json_str = Effect.yield(json:encode(luarc))

        local exists = Effect.yield(fs:exist(config_path))
        if exists then
            return { path = config_path, saved = "no-already-exists" }
        end
        Effect.yield(fs:write_file_string(config_path, json_str))
        return { path = config_path, saved = "yes" }
    end)
end

---comment
---@param target any
---@return fun(effect: Effect<any>):Effect<my.luarcjson.write_luarc_json_Result>
M.create_luarc_json = function(target)
    return Effect.async(function(rt)
        local xdg = rt:resolve(XdgDirs)
        local path_svc = rt:resolve(Path)
        local json = rt:resolve(JSON)
        local env = rt:resolve(Env)
        local fs = rt:resolve(FileSystem)

        local config_path = path_svc:join(xdg:config(), target)
        local luarc = M.luarc(path_svc, xdg, env)
        local json_str = rt:await(json:encode(luarc))

        local exists = rt:await(fs:exist(config_path))
        if exists then
            return write_luarc_json_result { path = config_path, saved = "no-already-exists" }
        end
        rt:await(fs:write_file_string(config_path, json_str))

        return write_luarc_json_result { path = config_path, saved = "yes" }
    end)
end

return M
