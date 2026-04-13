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

vim.opt.rtp:prepend("/home/kbroom/dev/kbroom/effectual")

local Effect = require("effectual.Effect")
local luarc = require("my.luarcjson")

local program = Effect.async(function(rt)
    local first = rt:yield(luarc.create_luarc_json(".luarc.json"))
    local second = rt:yield(luarc.create_luarc_json("two2.json"))
    return first.saved .. " AND " .. second.saved ---@type string
end)

local function main()
    local effect = Effect.root()
    require("effectual-nvim").setup(effect)
    local runner = program(effect)
---@diagnostic disable-next-line: undefined-field
    local before = vim.inspect({ before = "run", deps = runner.args._dependencies })
    vim.api.nvim_echo({ { before, "Title" } }, true, {})

    Effect.run(runner, function(err, value)
        if err then
            vim.notify("Error: " .. err, vim.log.levels.ERROR)
            return
        end
        if not value then
            vim.notify("No result", vim.log.levels.ERROR)
            return
        end
        local result = vim.inspect({ result = value, after = "run" })
        vim.api.nvim_echo({ { result, "Title" } }, true, {})
    end)
end

main()
