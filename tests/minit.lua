#!/usr/bin/env -S nvim -l

vim.env.LAZY_STDPATH = ".tests"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy.minit").setup({
  spec = {
    { dir = vim.uv.cwd() },
  },
})

require("globals").setup()
require("tests.matchers").setup()
