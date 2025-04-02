local GithubCopilot = {
    "github/copilot.vim",
}

local GithubCopilotChat = {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
        { "github/copilot.vim" },                       -- or zbirenbaum/copilot.lua
        { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                            -- Only on MacOS or Linux
    opts = {
        -- See Configuration section for options
        --   -- default window options
        window = {
            layout = 'vertical',  -- 'vertical', 'horizontal', 'float', 'replace'
            width = 0.3,          -- fractional width of parent, or absolute width in columns when > 1
            height = 0.5,         -- fractional height of parent, or absolute height in rows when > 1
            -- Options below only apply to floating windows
            relative = 'editor',  -- 'editor', 'win', 'cursor', 'mouse'
            border = 'single',    -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
            row = nil,            -- row position of the window, default is centered
            col = nil,            -- column position of the window, default is centered
            title = 'Copilot Chat', -- title of chat window
            footer = nil,         -- footer of chat window
            zindex = 1,           -- determines if window is on top or below other floating windows
        },
    },
    -- See Commands section for default commands if you want to lazy load on them
}

return {
    GithubCopilot,
    GithubCopilotChat,
}
