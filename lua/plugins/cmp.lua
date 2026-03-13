---@type LazyPluginSpec[]
local plugins = {}

---@type LazyPluginSpec
local FriendlySnippets = {
  url = "https://github.com/rafamadriz/friendly-snippets.git",
  -- commit 6cd7280 (date unknown, from lazy-lock) https://github.com/rafamadriz/friendly-snippets/commit/6cd7280adead7f586db6fccbd15d2cac7e2188b9
  commit = "6cd7280adead7f586db6fccbd15d2cac7e2188b9",
}

---@type LazyPluginSpec
local LuaSnip = {
  url = "https://github.com/L3MON4D3/LuaSnip.git",
  -- commit dae4f5a (date unknown, from lazy-lock) https://github.com/L3MON4D3/LuaSnip/commit/dae4f5aaa3574bd0c2b9dd20fb9542a02c10471c
  commit = "dae4f5aaa3574bd0c2b9dd20fb9542a02c10471c",
  build = (function()
    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
      return
    end
    return "make install_jsregexp"
  end)(),
  dependencies = { FriendlySnippets },
}

---@type LazyPluginSpec
local CmpLuasnip = {
  url = "https://github.com/saadparwaiz1/cmp_luasnip.git",
  -- commit 98d9cb5 (date unknown, from lazy-lock) https://github.com/saadparwaiz1/cmp_luasnip/commit/98d9cb5c2c38532bd9bdb481067b20fea8f32e90
  commit = "98d9cb5c2c38532bd9bdb481067b20fea8f32e90",
}

---@type LazyPluginSpec
local CmpNvimLsp = {
  url = "https://github.com/hrsh7th/cmp-nvim-lsp.git",
  -- commit cbc7b02 (date unknown, from lazy-lock) https://github.com/hrsh7th/cmp-nvim-lsp/commit/cbc7b02bb99fae35cb42f514762b89b5126651ef
  commit = "cbc7b02bb99fae35cb42f514762b89b5126651ef",
}

---@type LazyPluginSpec
local CmpPath = {
  url = "https://github.com/hrsh7th/cmp-path.git",
  -- commit c642487 (date unknown, from lazy-lock) https://github.com/hrsh7th/cmp-path/commit/c642487086dbd9a93160e1679a1327be111cbc25
  commit = "c642487086dbd9a93160e1679a1327be111cbc25",
}

---@type LazyPluginSpec
local CmpBuffer = {
  url = "https://github.com/hrsh7th/cmp-buffer.git",
  -- commit b74fab3 (date unknown, from lazy-lock) https://github.com/hrsh7th/cmp-buffer/commit/b74fab3656eea9de20a9b8116afa3cfc4ec09657
  commit = "b74fab3656eea9de20a9b8116afa3cfc4ec09657",
}

---@type LazyPluginSpec
local CmpCmdline = {
  url = "https://github.com/hrsh7th/cmp-cmdline.git",
  -- commit d126061 (date unknown, from lazy-lock) https://github.com/hrsh7th/cmp-cmdline/commit/d126061b624e0af6c3a556428712dd4d4194ec6d
  commit = "d126061b624e0af6c3a556428712dd4d4194ec6d",
}

---@type LazyPluginSpec
local NvimCmp = {
  url = "https://github.com/hrsh7th/nvim-cmp.git",
  -- commit da88697 (date unknown, from lazy-lock) https://github.com/hrsh7th/nvim-cmp/commit/da88697d7f45d16852c6b2769dc52387d1ddc45f
  commit = "da88697d7f45d16852c6b2769dc52387d1ddc45f",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    LuaSnip,
    CmpLuasnip,
    CmpNvimLsp,
    CmpPath,
    CmpBuffer,
    CmpCmdline,
  },
  opts = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    local setup = {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-y>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
        ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<C-l>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "path" },
        { name = "buffer" },
      }),
    }

    local cmdline = {
      search = {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      },
      cmd = {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      },
    }

    return {
      setup = setup,
      cmdline = cmdline,
    }
  end,
  config = function(_, opts)
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.config.setup({})

    cmp.setup(opts.setup)
    cmp.setup.cmdline({ "/", "?" }, opts.cmdline.search)
    cmp.setup.cmdline(":", opts.cmdline.cmd)
  end,
}

plugins[#plugins + 1] = NvimCmp

return plugins
