---@type LazyPluginSpec
local Markdown = {
  url = "https://github.com/MeanderingProgrammer/render-markdown.nvim.git",
  -- commit 1c95813 (date unknown, from lazy-lock) https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/1c958131c083c8557ea499fdb08c88b8afb05c4e
  commit = "1c958131c083c8557ea499fdb08c88b8afb05c4e",
  opts = function()
    return {}
  end,
}

return {
  Markdown,
}
