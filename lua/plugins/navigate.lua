local function nav_to_file(n)
  return function()
    local ui = require("harpoon.ui")
    ui.nav_file(n)
  end, { desc = string.format("Harpoon ui nav file %s", n) }
end

---@type LazyPluginSpec
local MarksNvim = {
  url = "https://github.com/chentoast/marks.nvim.git",
  -- commit f353e8c (date unknown, from lazy-lock) https://github.com/chentoast/marks.nvim/commit/f353e8c08c50f39e99a9ed474172df7eddd89b72
  commit = "f353e8c08c50f39e99a9ed474172df7eddd89b72",
  event = "VeryLazy",
  opts = function()
    return {}
  end,
}

---@type LazyPluginSpec
local Harpoon = {
  url = "https://github.com/ThePrimeagen/harpoon.git",
  -- commit 1bc17e3 (date unknown, from lazy-lock) https://github.com/ThePrimeagen/harpoon/commit/1bc17e3e42ea3c46b33c0bbad6a880792692a1b3
  commit = "1bc17e3e42ea3c46b33c0bbad6a880792692a1b3",
  config = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")
    vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "[Harpoon] mark add file" })
    vim.keymap.set("n", "<leader>hs", ui.toggle_quick_menu, { desc = "[Harpoon] ui toggle quick menu" })
    vim.keymap.set("n", "<leader>hh", nav_to_file(1), { desc = "[Harpoon] 1" })
    vim.keymap.set("n", "<leader>hj", nav_to_file(2), { desc = "[Harpoon] 2" })
    vim.keymap.set("n", "<leader>hk", nav_to_file(3), { desc = "[Harpoon] 3" })
    vim.keymap.set("n", "<leader>hl", nav_to_file(4), { desc = "[Harpoon] 4" })
  end,
}

return {
  MarksNvim,
  Harpoon,
}
