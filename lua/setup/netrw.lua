local M = {}

function M.setup()
    -- {{{ netrw
    vim.g.netrw_banner = 0
    vim.g.netrw_liststyle = 0 --> 0: Simple, 1: Detailed, 2: Thick, 3: Tree
    vim.g.netrw_browse_split = 3 --> Open file in 0: Reuse the same win, 1: Horizontal split, 2: Vertical split, 3: New tab
    vim.g.netrw_winsize = 25 --> seems to be in percentage

    vim.g.is_netrw_open = false
    --- Toggles netrw
    --- Requires vim.g.is_netrw_open global variable to function properly
    local function toggle_netrw()
        local fn = vim.fn
        if vim.g.is_netrw_open then
            for i = 1, fn.bufnr("$") do
                if fn.getbufvar(i, "&filetype") == "netrw" then
                    vim.cmd("bwipeout " .. i)
                end
            end
            vim.g.is_netrw_open = false
        else
            vim.cmd("Lex")
            vim.g.is_netrw_open = true
        end
    end
    vim.keymap.set("n", "<leader>n", toggle_netrw,
        { silent = true, noremap = true, desc = "Toggle [N]etrw" })
    -- }}}
end

return M
