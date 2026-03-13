--- plugins/telescope.lua
--- Telescope settings
---@require ripgrep: https://github.com/BurntSushi/ripgrep
---@require C compiler
---@require Make

---@type LazyPluginSpec[]
local plugins = {}

---@type LazyPluginSpec
local Plenary = {
  url = "https://github.com/nvim-lua/plenary.nvim.git",
  -- commit b9fd522 (date unknown, from lazy-lock) https://github.com/nvim-lua/plenary.nvim/commit/b9fd5226c2f76c951fc8ed5923d85e4de065e509
  commit = "b9fd5226c2f76c951fc8ed5923d85e4de065e509",
}

---@type LazyPluginSpec
local TelescopeFzfNative = {
  url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim.git",
  -- commit 6fea601 (date unknown, from lazy-lock) https://github.com/nvim-telescope/telescope-fzf-native.nvim/commit/6fea601bd2b694c6f2ae08a6c6fab14930c60e2c
  commit = "6fea601bd2b694c6f2ae08a6c6fab14930c60e2c",
  build = "make",
  cond = function()
    return vim.fn.executable("make") == 1
  end,
}

---@type LazyPluginSpec
local TelescopeUiSelect = {
  url = "https://github.com/nvim-telescope/telescope-ui-select.nvim.git",
  -- commit 6e51d7d (date unknown, from lazy-lock) https://github.com/nvim-telescope/telescope-ui-select.nvim/commit/6e51d7da30bd139a6950adf2a47fda6df9fa06d2
  commit = "6e51d7da30bd139a6950adf2a47fda6df9fa06d2",
}

---@type LazyPluginSpec
local TelescopeFileBrowser = {
  url = "https://github.com/nvim-telescope/telescope-file-browser.nvim.git",
  -- commit 3610dc7 (date unknown, from lazy-lock) https://github.com/nvim-telescope/telescope-file-browser.nvim/commit/3610dc7dc91f06aa98b11dca5cc30dfa98626b7e
  commit = "3610dc7dc91f06aa98b11dca5cc30dfa98626b7e",
}

---@type LazyPluginSpec
local Telescope = {
  url = "https://github.com/nvim-telescope/telescope.nvim.git",
  -- commit a0bbec2 (date unknown, from lazy-lock) https://github.com/nvim-telescope/telescope.nvim/commit/a0bbec21143c7bc5f8bb02e0005fa0b982edc026
  commit = "a0bbec21143c7bc5f8bb02e0005fa0b982edc026",
  event = "VimEnter",
  dependencies = {
    Plenary,
    TelescopeFzfNative,
    TelescopeUiSelect,
    TelescopeFileBrowser,
  },
  opts = function()
    local themes = require("telescope.themes")
    return {
      setup = {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
        extensions = {
          ["ui-select"] = themes.get_dropdown(),
          file_browser = { hidden = true },
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts.setup)

    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
    pcall(telescope.load_extension, "file_browser")

    local builtin = require("telescope.builtin")
    ---@diagnostic disable-next-line: different-requires
    local extensions = require("extensions.telescope")

    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sd", extensions.diagnostics_with_sources, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files ('.' for repeat)" })
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

    vim.keymap.set("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "[S]earch [/] in Open Files" })

    vim.keymap.set("n", "<leader>sn", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "[S]earch [N]eovim files" })

    vim.keymap.set("n", "<leader>gf",
      function() builtin.git_files({ show_untracked = true }) end,
      { desc = "Search [G]it [F]iles" }
    )
    vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Search [G]it [C]ommits" })
    vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Search [G]it [S]tatus" })

    vim.keymap.set("n", "<leader>fb", telescope.extensions.file_browser.file_browser, { desc = "[F]ile [B]rowser" })
  end,
}

plugins[#plugins + 1] = Telescope

return plugins
