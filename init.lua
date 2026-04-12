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
    local effect = Effect.succeed(nil)
    FileSystem.set(effect, NvimFileSystem)

    Effect.run(program(effect), function(result)
        local value = vim.inspect({ result = result, after = "run" })
        vim.api.nvim_echo({ { value, "after", } }, true, {})
        if result.saved == "no-error" then
            vim.notify("Failed to write .luarc.json", vim.log.levels.ERROR)
        end
    end)
end

main()
