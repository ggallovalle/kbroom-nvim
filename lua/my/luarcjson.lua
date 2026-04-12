local Effect = require("effect.Effect")
local FileSystem = require("effect.FileSystem")
local JSON = require("effect.JSON")
local Path = require("effect.Path")

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
---@return Effect<{path: string, saved: "yes" | "no-already-exists"}>
function M.write_luarc_json(effect)
  return Effect.gen(function()
    local path = Effect.yield(Path.get(effect))
    local config_path = path:join(vim.fn.stdpath("config"), ".luarc.json")

    local json = Effect.yield(JSON.get(effect))
    local luarc = M.luarc()
    local json_str = Effect.yield(json:encode(luarc))

    local fs = Effect.yield(FileSystem.get(effect))
    local exists = Effect.yield(fs:exist(config_path))
    if exists then
      return { path = config_path, saved = "no-already-exists" }
    end
    Effect.yield(fs:write_file_string(config_path, json_str))
    return { path = config_path, saved = "yes" }
  end)
end

return M
