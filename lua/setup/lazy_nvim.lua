local M = {}

function M.setup()
    -- {{{ lazy.nvim
    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out,                            "WarningMsg" },
                --{ "\nPress any key to exit..." },
            }, true, {})
            --vim.fn.getchar()
            --os.exit(1)
        end
    end
    vim.opt.rtp:prepend(lazypath)

    -- Either pass the table (containing the plugin info) or string (a directory containing Lua modules)
    -- Following will import all Lua files in lua/plugins
    require("lazy").setup("plugins")
    -- }}}
end

return M