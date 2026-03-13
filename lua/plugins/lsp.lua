---@type LazyPluginSpec[]
local plugins = {}

---@type LazyPluginSpec
local Mason = {
  url = "https://github.com/williamboman/mason.nvim.git",
  -- commit 44d1e90 (date unknown, from lazy-lock) https://github.com/williamboman/mason.nvim/commit/44d1e90e1f66e077268191e3ee9d2ac97cc18e65
  commit = "44d1e90e1f66e077268191e3ee9d2ac97cc18e65",
  config = true,
}

---@type LazyPluginSpec
local MasonLspconfig = {
  url = "https://github.com/williamboman/mason-lspconfig.nvim.git",
  -- commit ae60952 (date unknown, from lazy-lock) https://github.com/williamboman/mason-lspconfig.nvim/commit/ae609525ddf01c153c39305730b1791800ffe4fe
  commit = "ae609525ddf01c153c39305730b1791800ffe4fe",
}

---@type LazyPluginSpec
local Fidget = {
  url = "https://github.com/j-hui/fidget.nvim.git",
  -- commit 7fa433a (date unknown, from lazy-lock) https://github.com/j-hui/fidget.nvim/commit/7fa433a83118a70fe24c1ce88d5f0bd3453c0970
  commit = "7fa433a83118a70fe24c1ce88d5f0bd3453c0970",
  opts = function()
    return {}
  end,
}

---@type LazyPluginSpec
local LazyDev = {
  url = "https://github.com/folke/lazydev.nvim.git",
  -- commit 5231c62 (date unknown, from lazy-lock) https://github.com/folke/lazydev.nvim/commit/5231c62aa83c2f8dc8e7ba957aa77098cda1257d
  commit = "5231c62aa83c2f8dc8e7ba957aa77098cda1257d",
  ft = "lua",
  opts = function()
    return {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    }
  end,
}

---@type LazyPluginSpec
local LuvitMeta = {
  url = "https://github.com/Bilal2453/luvit-meta.git",
  -- commit 0ea4ff6 (date unknown, from lazy-lock) https://github.com/Bilal2453/luvit-meta/commit/0ea4ff636c5bb559ffa78108561d0976f4de9682
  commit = "0ea4ff636c5bb559ffa78108561d0976f4de9682",
  lazy = true,
}

---@type LazyPluginSpec
local Navic = {
  url = "https://github.com/SmiteshP/nvim-navic.git",
  -- commit f5eba19 (date unknown, from lazy-lock) https://github.com/SmiteshP/nvim-navic/commit/f5eba192f39b453675d115351808bd51276d9de5
  commit = "f5eba192f39b453675d115351808bd51276d9de5",
  lazy = true,
}

---@type LazyPluginSpec
local Phpactor = {
  url = "https://github.com/phpactor/phpactor.git",
  -- commit a7b81ef (date unknown, from lazy-lock) https://github.com/phpactor/phpactor/commit/a7b81ef15ce0945126cf0deec8dd624a01379660
  commit = "a7b81ef15ce0945126cf0deec8dd624a01379660",
  ft = "php",
  build = "composer install --no-dev --optimize-autoloader",
}

local H = {}

H.config_mason = function()
  require("mason").setup()

  local vue_language_server_path = vim.fn.stdpath("data")
    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
  local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
  local vue_plugin = {
    name = "@vue/typescript-plugin",
    location = vue_language_server_path,
    languages = { "vue" },
    configNamespace = "typescript",
  }

  local servers = {
    bashls = {},
    texlab = {},
    basedpyright = {},
    ruff = {},
    ts_ls = {
      init_options = {
        plugins = {
          vue_plugin,
        },
      },
      filetypes = tsserver_filetypes,
    },
    vue_ls = {},
    lua_ls = {
      settings = {
        Lua = {
          telemetry = { enable = false },
        },
      },
    },
    phpactor = {},
    rust_analyzer = {},
  }

  for server, config in pairs(servers) do
    vim.lsp.config(server, config)
  end

  require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_keys(servers or {}),
    automatic_enable = true,
  })
end

---@type LazyPluginSpec
local LspConfig = {
  url = "https://github.com/neovim/nvim-lspconfig.git",
  -- commit 66fd02a (date unknown, from lazy-lock) https://github.com/neovim/nvim-lspconfig/commit/66fd02ad1c7ea31616d3ca678fa04e6d0b360824
  commit = "66fd02ad1c7ea31616d3ca678fa04e6d0b360824",
  dependencies = {
    Mason,
    MasonLspconfig,
    Fidget,
    LazyDev,
    LuvitMeta,
    Navic,
    Phpactor,
  },
  config = function()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
      title = "Hover",
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
      title = "Signature Help",
    })

    local kbroom_lsp_config_group = vim.api.nvim_create_augroup("KBroomLspConfig", { clear = true })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = kbroom_lsp_config_group,
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("<leader>F", vim.lsp.buf.format, "[F]ormat buffer")

        local status, builtin = pcall(require, "telescope.builtin")
        local telescope_opt_tab = { jump_type = "tab" }
        local telescope_opt = telescope_opt_tab
        local telescope_opt_split = { jump_type = "split" }
        local telescope_opt_vsplit = { jump_type = "vsplit" }
        local telescope_opt_tabdrop = { jump_type = "tab drop" }

        map("gdt", status and function()
          builtin.lsp_definitions(telescope_opt_tab)
        end or vim.lsp.buf.definition, "[G]oto [D]efinition [T]ab")
        map("gds", status and function()
          builtin.lsp_definitions(telescope_opt_split)
        end or vim.lsp.buf.definition, "[G]oto [D]efinition [S]plit")
        map("gdv", status and function()
          builtin.lsp_definitions(telescope_opt_vsplit)
        end or vim.lsp.buf.definition, "[G]oto [D]efinition [V]split")
        map("gdd", status and function()
          builtin.lsp_definitions(telescope_opt_tabdrop)
        end or vim.lsp.buf.definition, "[G]oto [D]efinition Tab [D]rop")

        map("gr", builtin.lsp_references or vim.lsp.buf.references, "[G]oto [R]eferences")
        map("gI", builtin.lsp_implementations or vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        map("<leader>D", status and function()
          builtin.lsp_type_definitions(telescope_opt)
        end or vim.lsp.buf.type_definition, "Type [D]efinition")

        map("<leader>ds", builtin.lsp_document_symbols or vim.lsp.buf.document_symbol, "[D]ocument [S]ymbols")
        map(
          "<leader>ws",
          builtin.lsp_dynamic_workspace_symbols or vim.lsp.buf.workspace_symbol,
          "[W]orkspace [S]ymbols"
        )

        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("gD", vim.lsp.buf.declaration, "[G]o [D]eclaration")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local kbroom_lsp_hl_group = vim.api.nvim_create_augroup("KBroomLspHl", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = kbroom_lsp_hl_group,
            callback = vim.lsp.buf.document_highlight,
          })

          local kbroom_lsp_detach_group = vim.api.nvim_create_augroup("KBroomLspHlDetach", { clear = true })
          vim.api.nvim_create_autocmd("LspDetach", {
            group = kbroom_lsp_detach_group,
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "KBroomLspHl", buffer = event2.buf })
            end,
          })
        end

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, "[T]oggle Inlay [H]ints")
        end

        if client and client.name == "basedpyright" then
          local navic = require("nvim-navic")
          navic.attach(client, event.buf)
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    H.config_mason()
  end,
}

plugins[#plugins + 1] = LspConfig

return plugins
