local settings = require("settings")
local gruvbox_overrides = require("colorschemes.catpuccin-gruvbox")

local Catppuccin = {
  "catppuccin/nvim",
  name = "catppuccin",
  main = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    highlight_overrides = {
      gruvbox = gruvbox_overrides.highlight_overrides.gruvbox
    },
  },
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
  end
}


local Gruvbox = {
  "ellisonleao/gruvbox.nvim",
  name = "gruvbox",
  main = "gruvbox",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(spec, opts)
    require(spec.main).setup(opts)

    if settings.colorscheme == spec.name then
      vim.cmd.colorscheme(spec.name)
    end
  end
}


local VsCode = {
  "Mofiqul/vscode.nvim",
  name = "vscode",
  main = "vscode",
  lazy = false,
  priority = 1000, --> Higher priority over other plugins
  opts = {
  },
  config = function(spec, opts)
    require(spec.main).setup(opts)

    if settings.colorscheme == spec.name then
      vim.cmd.colorscheme(spec.name)
    end
  end
}


local Github = {
  url = "https://github.com/projekt0n/github-nvim-theme",
  -- 2024-08-05
  tag = "v1.1.2",
  main = "github-theme",
  lazy = false,
  priority = 1000, --> Higher priority over other plugins
  opts = {
  },
  config = function(spec, opts)
    require(spec.main).setup(opts)

    vim.api.nvim_del_user_command("GithubThemeInteractive")
    vim.api.nvim_del_user_command("GithubThemeCompile")

    if settings.colorscheme == "github" then
      vim.cmd.colorscheme("github_" .. settings.colorscheme_flavor)
    end
  end
}

local OneDark = {
  url = "https://github.com/navarasu/onedark.nvim",
  -- 2024-07-05
  commit = "fae34f7c635797f4bf62fb00e7d0516efa8abe37",
  name = "onedark",
  main = "onedark",
  lazy = false,
  priority = 1000, --> Higher priority over other plugins
  opts = {
  },
  config = function(spec, opts)
    if settings.colorscheme == spec.name then
      opts.style = settings.colorscheme_flavor
    end

    require(spec.main).setup(opts)
    if settings.colorscheme == spec.name then
      vim.cmd.colorscheme(spec.name)
    end
  end
}


local Nord = {
  url = "https://github.com/shaunsingh/nord.nvim",
  -- 2023-12-19
  commit = "80c1e5321505aeb22b7a9f23eb82f1e193c12470",
  name = "nord",
  main = "nord",
  lazy = false,
  priority = 1000, --> Higher priority over other plugins
  opts = {
  },
  config = function(spec, opts)
    vim.g.nord_borders = true
    vim.g.nord_disable_background = false
    vim.g.nord_italic = true
    vim.g.nord_uniform_diff_background = true
    vim.g.nord_bold = false

    if settings.colorscheme == spec.name then
      vim.cmd.colorscheme(spec.name)
    end
  end
}


local TokyoNight = {
  "folke/tokyonight.nvim",
  name = "tokyonight",
  main = "tokyonight",
  lazy = false,
  priority = 1000, --> Higher priority over other plugins
  opts = {
    transparent = settings.colorscheme_is_transparent,
    styles = {
      sidebars = settings.colorscheme_is_transparent and "transparent" or "dark",
      floats = settings.colorscheme_is_transparent and "transparent" or "dark",
    },
    plugins = {
      mini_statusline = true,
      mini_starter = true,
    },
  },
  config = function(spec, opts)
    require(spec.main).setup(opts)

    if settings.colorscheme == spec.name then
      vim.cmd.colorscheme("tokyonight-" .. settings.colorscheme_flavor)
    end
  end,
}

return {
  Catppuccin,
  Gruvbox,
  VsCode,
  Github,
  OneDark,
  Nord,
  TokyoNight,
}
