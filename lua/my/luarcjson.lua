local Effect = require("effect.Effect")
local FileSystem = require("effect.FileSystem")
local F = require("effect.F")

local M = {}

M.luarc = function()
    local data_path = vim.fn.stdpath("data")

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
                vim.env.VIMRUNTIME,
                data_path .. "/lazy",
            },
        },
    }
    return luarc
end

---Write .luarc.json to nvim config directory
---@param effect Effect<any>
---@return Effect<{path: string, saved: "yes" | "no-already-exists" | "no-error"}>
function M.write_luarc_json(effect)
    local config_path = vim.fs.joinpath(vim.fn.stdpath("config"), ".luarc.json")
    local luarc = M.luarc()
    local json_str = vim.fn.json_encode(luarc)

    return F.pipe2(
        FileSystem.get(effect),
        Effect.flatMap(function(fs)
            return Effect.callback(function(callback)
                fs:exist(config_path, function(exists)
                    if exists then
                        callback({ path = config_path, saved = "no-already-exists" })
                        return
                    end
                    fs:write_file_string(config_path, json_str, function(err, bytes)
                        if err then
                            callback({ path = config_path, saved = "no-error" })
                        else
                            callback({ path = config_path, saved = "yes" })
                        end
                    end)
                end)
            end)
        end)
    )
end

return M