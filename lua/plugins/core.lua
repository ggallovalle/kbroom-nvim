---@type LazyPluginSpec
local Plenary = {
  url = "https://github.com/nvim-lua/plenary.nvim.git",
  -- last version check: 2025-03-15
  -- commit date: 2025-06-26
  commit = "b9fd5226c2f76c951fc8ed5923d85e4de065e509",
}

---@type LazyPluginSpec
local Devicons = {
  url = "https://github.com/nvim-tree/nvim-web-devicons.git",
  -- commit 746ffbb (date unknown, from lazy-lock) https://github.com/nvim-tree/nvim-web-devicons/commit/746ffbb17975ebd6c40142362eee1b0249969c5c
  commit = "746ffbb17975ebd6c40142362eee1b0249969c5c",
}

return {
  Plenary,
  Devicons,
}
