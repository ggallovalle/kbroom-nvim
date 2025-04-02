local MarksNvim = {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
}

local function nav_to_file(n)
    return function()
        local ui = require("harpoon.ui")
        ui.nav_file(n)
    end, { desc = string.format("Harpoon ui nav file %s", n) }
end

local Harpoon = {
    "ThePrimeagen/harpoon"
}

Harpoon.config = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")
    vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "[Harpoon] mark add file" })
    vim.keymap.set("n", "<leader>hs", ui.toggle_quick_menu, { desc = "[Harpoon] ui toggle quick menu" })
    vim.keymap.set("n", "<leader>hh", nav_to_file(1), { desc = "[Harpoon] 1" })
    vim.keymap.set("n", "<leader>hj", nav_to_file(2), { desc = "[Harpoon] 2" })
    vim.keymap.set("n", "<leader>hk", nav_to_file(3), { desc = "[Harpoon] 3" })
    vim.keymap.set("n", "<leader>hl", nav_to_file(4), { desc = "[Harpoon] 4" })
end

return {
    MarksNvim,
    Harpoon,
}
