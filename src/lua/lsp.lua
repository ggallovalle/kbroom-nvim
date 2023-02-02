--[[
" figlet -f stacey theovim-lsp
" ________________________________ _____________________   ______________
" 7      77  7  77     77     77  V  77  77        77  7   7     77     7
" !__  __!|  !  ||  ___!|  7  ||  |  ||  ||  _  _  ||  |   |  ___!|  -  |
"   7  7  |     ||  __|_|  |  ||  !  ||  ||  7  7  ||  !___!__   7|  ___!
"   |  |  |  7  ||     7|  !  ||     ||  ||  |  |  ||     77     ||  7
"   !__!  !__!__!!_____!!_____!!_____!!__!!__!__!__!!_____!!_____!!__!
--]]

-- List of LSP server used later
-- MasonInstall bash-language-server, clangd, css-lsp, html-lsp, lua-language-server, python-lsp-server, remark-language-server, sqlls
-- Always check the memory usage of each language server. :LSpInfo to identify LSP server and use "sudo lsof -p PID" to check for associated files
-- Blacklist: ltex-ls (java process running in the bg for each instance of markdown files)
local server_list = {
  "bashls", "clangd", "sumneko_lua", "pylsp", "sqlls",
}

local theo_server_recommendations = {
  "cssls", "html"
}

-- {{{ Call lspconfig settings
local status, lspconfig = pcall(require, "lspconfig")
if (not status) then return end
-- }}}

-- {{{ Language Server Settings
-- Capabilities and on_attach function that will be called for all LSP servers
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local code_format_status = true --> boolean var for auto formatting toggle
local on_attach = function(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    -- Making a toggle for automatic formatting
    vim.api.nvim_create_user_command("CodeFormatToggle",
      function()
        code_format_status = not code_format_status
        -- (code_format_status) ? ("On") : ("Off") Lua plz support conditional ternary op
        vim.notify("Code Auto Format " .. (code_format_status and "On!" or "Off!"))
      end,
      { nargs = 0 })

    -- Autocmd for code formatting on the write
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = true }),
      buffer = bufnr,
      callback = function()
        if code_format_status then vim.lsp.buf.format() end
      end
    })

  end
end

-- Let Mason-lspconfig handle LSP setup
require("mason-lspconfig").setup {
  ensure_installed = server_list,
  automatic_installation = true,
}

require("mason-lspconfig").setup_handlers({
  -- Default handler
  function(server_name)
    require("lspconfig")[server_name].setup({ capabilities = capabilities, on_attach = on_attach })
  end,
  -- Lua gets a special treatment just for the vim.all_the_fun_stuff
  ["sumneko_lua"] = function()
    lspconfig.sumneko_lua.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" }
          },
        },
      },
    })
  end,
})
-- }}}

-- {{{ nvim-cmp setup
-- Table for icons
local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "ﰠ",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "塞",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "פּ",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

-- Helper function for tab completion
local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local cmp = require "cmp"
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-j>"] = cmp.mapping.select_next_item(), --> <C-n>
    ["<C-k>"] = cmp.mapping.select_prev_item(), --> <C-p>
    ["<C-e>"] = cmp.mapping.abort(), --> Close the completion window
    ["<C-[>"] = cmp.mapping.scroll_docs(-4), --> Scroll through the information window next to the item
    ["<C-]>"] = cmp.mapping.scroll_docs(4), --> ^
    ["<C-Space>"] = cmp.mapping.complete(), --> Brings up completion window without
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select }) --> <C-n> if completion window is open
      elseif check_backspace() then
        fallback() --> Default action (tab char or shiftwidth) if the line is empty
      else
        cmp.complete() --> Open completion window. Change it to fallback() if you want to insert tab in between lines
      end
    end, { 'i', 's' }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  }),
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      -- Source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[LaTeX]",
      })[entry.source.name]
      return vim_item
    end
  },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
