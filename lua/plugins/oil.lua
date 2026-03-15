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
  "__pycache__",
}

---@type LazyPluginSpec
local Oil = {
  url = "https://github.com/stevearc/oil.nvim.git",
  -- commit 975a77c (date unknown, from lazy-lock) https://github.com/stevearc/oil.nvim/commit/975a77cce3c8cb742bc1b3629f4328f5ca977dad
  commit = "975a77cce3c8cb742bc1b3629f4328f5ca977dad",
  keys = {
    { "<leader>fo", "<cmd>Oil --preview <cr>", desc = "[File] [O]il" },
  },
  opts = function()
    return {
      default_file_explorer = false, --> do not hijack netrw
      view_options = {
        is_hidden_file = function(name, _)
          return contains(hidden, name, vim.startswith)
        end,
        is_always_hidden = function(name, _)
          return contains(always_hidden, name, vim.startswith)
        end,
      },
    }
  end,
}

return {
  Oil,
}
