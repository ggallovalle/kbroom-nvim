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
local NvimFileSystem = require("effect-nvim.FileSystem")

---@param effect Effect<any>
local function program(effect)
    return luarc.write_luarc_json(effect)
end

local function main()
    local effect = Effect.root()
    FileSystem.set(effect, NvimFileSystem)

    Effect.run(program(effect), function(err, value)
        if err then
            vim.notify("Error: " .. err, vim.log.levels.ERROR)
            return
        end
        assert(value)
        local result = vim.inspect({ result = value, after = "run" })
        vim.api.nvim_echo({ { result, "after", } }, true, {})
        if value.saved == "no-error" then
            vim.notify("Failed to write .luarc.json", vim.log.levels.ERROR)
        end
    end)
end

main()
