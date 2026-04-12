local FileSystem = require("effect.FileSystem")

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

---@param effect effect.Effect
M.write_luarc_json = function(effect)
    FileSystem.get(effect, function(fs)
        local config_path = vim.fs.joinpath(vim.fn.stdpath("config"), ".luarc.json")
        local luarc = M.luarc()
        local json_str = vim.fn.json_encode(luarc)

        fs:exist(config_path, function(exists)
            if exists then
                return
            end

            fs:write_file_string(config_path, json_str, function(err, bytes)
                if err then
                    vim.notify("Failed to write .luarc.json: " .. err, vim.log.levels.ERROR)
                end
            end)
        end)
    end)
end

return M
