local function contains(array, value, eq)
  for _, v in ipairs(array) do
    if eq(value, v) then
      return true
    end
  end
  return false
end

local hidden = {
  ".",
}

local always_hidden = {
  "__pycache__"
}

return {
  "stevearc/oil.nvim",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
  },
  opts = {
    default_file_explorer = false, --> do not hijack netrw
    view_options = {
      -- This function defines what is considered a "hidden" file
      is_hidden_file = function(name, bufnr)
        return contains(hidden, name, vim.startswith)
      end,
      -- This function defines what will never be shown, even when `show_hidden` is set
      is_always_hidden = function(name, bufnr)
        return contains(always_hidden, name, vim.startswith)
      end,
    }
  },
}
