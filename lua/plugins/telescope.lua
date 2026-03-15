---@type LazyPluginSpec
local TelescopeFzfNative = {
  url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim.git",
  -- last version check: 2026-03-15
  -- commit date: 2025-11-07
  commit = "6fea601bd2b694c6f2ae08a6c6fab14930c60e2c",
  build = "make",
  cond = function()
    return vim.fn.executable("make") == 1
  end,
}

---@type LazyPluginSpec
local Telescope = {
  url = "https://github.com/nvim-telescope/telescope.nvim.git",
  -- last version check: 2026-03-15
  -- commit date: 2026-02-16
  commit = "5255aa27c422de944791318024167ad5d40aad20",
  event = "VimEnter",
  dependencies = {
    TelescopeFzfNative,
  },
  opts = function()
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
        extensions = {},
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts.setup)

    pcall(telescope.load_extension, "fzf")

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

    vim.keymap.set("n", "<leader>gf", function()
      builtin.git_files({ show_untracked = true })
    end, { desc = "Search [G]it [F]iles" })
    vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Search [G]it [C]ommits" })
    vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Search [G]it [S]tatus" })
  end,
}

return {
  Telescope,
}
