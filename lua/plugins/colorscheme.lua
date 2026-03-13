local settings = require("settings")
local gruvbox_overrides = require("colorschemes.catpuccin-gruvbox")

---@type LazyPluginSpec
local Catppuccin = {
  url = "https://github.com/catppuccin/nvim.git",
  -- commit beaf41a (date unknown, from lazy-lock) https://github.com/catppuccin/nvim/commit/beaf41a30c26fd7d6c386d383155cbd65dd554cd
  commit = "beaf41a30c26fd7d6c386d383155cbd65dd554cd",
  name = "catppuccin",
  main = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = function()
    return {
      highlight_overrides = {
        gruvbox = gruvbox_overrides.highlight_overrides.gruvbox,
      },
    }
  end,
  config = function(spec, opts)
    local cat = require(spec.main)
    cat.flavours.gruvbox = 5
    cat.flavours["vscode-dark"] = 6

    if settings.colorscheme == spec.name then
      opts.flavour = settings.colorscheme_flavor
    end

    cat.setup(opts)
    vim.api.nvim_del_user_command("Catppuccin")
    vim.api.nvim_del_user_command("CatppuccinCompile")

    if settings.colorscheme == spec.name then
      vim.cmd.colorscheme(settings.colorscheme)
    end
  end,
}

---@type LazyPluginSpec
local Gruvbox = {
  url = "https://github.com/ellisonleao/gruvbox.nvim.git",
  -- commit a472496 (date unknown, from lazy-lock) https://github.com/ellisonleao/gruvbox.nvim/commit/a472496e1a4465a2dd574389dcf6cdb29af9bf1b
  commit = "a472496e1a4465a2dd574389dcf6cdb29af9bf1b",
  name = "gruvbox",
  main = "gruvbox",
  lazy = false,
  priority = 1000,
  opts = function()
    return {}
  end,
  config = function(spec, opts)
    require(spec.main).setup(opts)
    if settings.colorscheme == spec.name then
      vim.cmd.colorscheme(spec.name)
    end
  end,
}

---@type LazyPluginSpec
local VsCode = {
  url = "https://github.com/Mofiqul/vscode.nvim.git",
  -- commit aa1102a (date unknown, from lazy-lock) https://github.com/Mofiqul/vscode.nvim/commit/aa1102a7e15195c9cca22730b09224a7f7745ba8
  commit = "aa1102a7e15195c9cca22730b09224a7f7745ba8",
  name = "vscode",
  main = "vscode",
  lazy = false,
  priority = 1000,
  opts = function()
    return {}
  end,
  config = function(spec, opts)
    require(spec.main).setup(opts)
    if settings.colorscheme == spec.name then
      vim.cmd.colorscheme(spec.name)
    end
  end,
}

---@type LazyPluginSpec
local Github = {
  url = "https://github.com/projekt0n/github-nvim-theme.git",
  -- commit 8db454e (date unknown, from lazy-lock) https://github.com/projekt0n/github-nvim-theme/commit/8db454eb272eabb349209ec62ceb63b8eea5f011
  commit = "8db454eb272eabb349209ec62ceb63b8eea5f011",
  main = "github-theme",
  lazy = false,
  priority = 1000,
  opts = function()
    return {}
  end,
  config = function(spec, opts)
    require(spec.main).setup(opts)

    vim.api.nvim_del_user_command("GithubThemeInteractive")
    vim.api.nvim_del_user_command("GithubThemeCompile")

    if settings.colorscheme == "github" then
      vim.cmd.colorscheme("github_" .. settings.colorscheme_flavor)
    end
  end,
}

---@type LazyPluginSpec
local OneDark = {
  url = "https://github.com/navarasu/onedark.nvim.git",
  -- commit fae34f7 (date unknown, from lazy-lock) https://github.com/navarasu/onedark.nvim/commit/fae34f7c635797f4bf62fb00e7d0516efa8abe37
  commit = "fae34f7c635797f4bf62fb00e7d0516efa8abe37",
  name = "onedark",
  main = "onedark",
  lazy = false,
  priority = 1000,
  opts = function()
    return {}
  end,
  config = function(spec, opts)
    if settings.colorscheme == spec.name then
      opts.style = settings.colorscheme_flavor
    end

    require(spec.main).setup(opts)
    if settings.colorscheme == spec.name then
      vim.cmd.colorscheme(spec.name)
    end
  end,
}

---@type LazyPluginSpec
local Nord = {
  url = "https://github.com/shaunsingh/nord.nvim.git",
  -- commit 80c1e53 (date unknown, from lazy-lock) https://github.com/shaunsingh/nord.nvim/commit/80c1e5321505aeb22b7a9f23eb82f1e193c12470
  commit = "80c1e5321505aeb22b7a9f23eb82f1e193c12470",
  name = "nord",
  main = "nord",
  lazy = false,
  priority = 1000,
  opts = function()
    return {}
  end,
  config = function(spec, opts)
    vim.g.nord_borders = true
    vim.g.nord_disable_background = false
    vim.g.nord_italic = true
    vim.g.nord_uniform_diff_background = true
    vim.g.nord_bold = false

    if settings.colorscheme == spec.name then
      vim.cmd.colorscheme(spec.name)
    end
  end,
}

---@type LazyPluginSpec
local TokyoNight = {
  url = "https://github.com/folke/tokyonight.nvim.git",
  -- commit 5da1b76 (date unknown, from lazy-lock) https://github.com/folke/tokyonight.nvim/commit/5da1b76e64daf4c5d410f06bcb6b9cb640da7dfd
  commit = "5da1b76e64daf4c5d410f06bcb6b9cb640da7dfd",
  name = "tokyonight",
  main = "tokyonight",
  lazy = false,
  priority = 1000,
  opts = function()
    return {
      transparent = settings.colorscheme_is_transparent,
      styles = {
        sidebars = settings.colorscheme_is_transparent and "transparent" or "dark",
        floats = settings.colorscheme_is_transparent and "transparent" or "dark",
      },
      plugins = {
        mini_statusline = true,
        mini_starter = true,
      },
    }
  end,
  config = function(spec, opts)
    require(spec.main).setup(opts)

    if settings.colorscheme == spec.name then
      vim.cmd.colorscheme("tokyonight-" .. settings.colorscheme_flavor)
    end
  end,
}

---@type LazyPluginSpec[]
local plugins_list = {
  Catppuccin,
  Gruvbox,
  VsCode,
  Github,
  OneDark,
  Nord,
  TokyoNight,
}

return plugins_list
