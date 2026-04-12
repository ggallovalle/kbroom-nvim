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

  return Effect.gen(function()
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
