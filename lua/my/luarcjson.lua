local Effect = require("effect.Effect")
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

---Write .luarc.json to nvim config directory
---@param effect Effect<any>
---@return Effect<{path: string, saved: "yes" | "no-already-exists"}>
function M.write_luarc_json(effect)
  local config_path = vim.fs.joinpath(vim.fn.stdpath("config"), ".luarc.json")
  local luarc = M.luarc()
  local json_str = vim.fn.json_encode(luarc)

  local get_fs = FileSystem.get(effect)
  local chained = Effect.flatMap(get_fs, function(fs)
    local check_exist = fs:exist(config_path)
    return Effect.flatMap(check_exist, function(exists)
      if exists then
        return Effect.succeed({ path = config_path, saved = "no-already-exists" })
      else
        local write = fs:write_file_string(config_path, json_str)
        return Effect.map(write, function(bytes)
          return { path = config_path, saved = "yes" }
        end)
      end
    end)
  end)

  return chained
end

return M
