-- requires version of nvim >= 0.12
local min_version = "0.12"
local current = vim.version()
local min = vim.version.parse(min_version)

if current < min then
    vim.notify(
        string.format("Neovim %s+ required, current: %s", min_version, current),
        vim.log.levels.ERROR,
        { title = "Version Check" }
    )
    return
end

local Effect = require("effect.Effect")
local FileSystem = require("effect.FileSystem")


local luarc = require("my.luarcjson")

---@param effect effect.Effect
local function program(effect)
    luarc.write_luarc_json(effect)
end

local NvimFileSystem = require("effect-nvim.FileSystem")

local function main()
    local effect = Effect.new()
    FileSystem.set(effect, NvimFileSystem)
    program(effect)
end

main()
