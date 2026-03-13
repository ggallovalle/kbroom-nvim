local H = {}

H.first_str = function(value)
  return value:sub(1, 1)
end

---@type LazyPluginSpec[]
local plugins = {}

---@type LazyPluginSpec
local Devicons = {
  url = "https://github.com/nvim-tree/nvim-web-devicons.git",
  -- commit 746ffbb (date unknown, from lazy-lock) https://github.com/nvim-tree/nvim-web-devicons/commit/746ffbb17975ebd6c40142362eee1b0249969c5c
  commit = "746ffbb17975ebd6c40142362eee1b0249969c5c",
}

---@type LazyPluginSpec
local Lualine = {
  url = "https://github.com/nvim-lualine/lualine.nvim.git",
  -- commit 47f91c4 (date unknown, from lazy-lock) https://github.com/nvim-lualine/lualine.nvim/commit/47f91c416daef12db467145e16bed5bbfe00add8
  commit = "47f91c416daef12db467145e16bed5bbfe00add8",
  dependencies = { Devicons },
  opts = function()
    return {
      sections = {
        lualine_a = { { 'mode', fmt = H.first_str } },
        lualine_b = { 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = { 'branch' },
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
  config = function(_, opts)
    require('lualine').setup(opts)
  end,
}

plugins[#plugins + 1] = Lualine

return plugins
