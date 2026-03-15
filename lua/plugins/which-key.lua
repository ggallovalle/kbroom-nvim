---@type LazyPluginSpec[]
local Whichkey = {
  url = "https://github.com/folke/which-key.nvim.git",
  -- commit 3aab214 (date unknown, from lazy-lock) https://github.com/folke/which-key.nvim/commit/3aab2147e74890957785941f0c1ad87d0a44c15a
  commit = "3aab2147e74890957785941f0c1ad87d0a44c15a",
  event = "VimEnter",
  opts = function()
    return {}
  end,
  config = function(_, _)
    require("which-key").setup()
    require("which-key").add({
      { "<leader>c", group = "[C]ode" },
      { "<leader>d", group = "[D]ocument" },
      { "<leader>f", group = "[F]ile" },
      { "<leader>g", group = "[G]it" },
      { "<leader>r", group = "[R]ename" },
      { "<leader>s", group = "[S]earch" },
      { "<leader>w", group = "[W]orkspace" },
      { "<leader>t", group = "[T]oggle / [T]erminal" },
      { "<leader>h", group = "[H]arpoon" },
    })
  end,
}

return {
  Whichkey,
}
