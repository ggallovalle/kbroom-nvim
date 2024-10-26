local M = {}

function M.setup()
  -- Excludes default Neovim options:
  -- https://neovim.io/doc/user/vim_diff.html#nvim-defaults

  -- Tab
  vim.opt.softtabstop    = 0    --> How many chracters the /cursor moves/ with <TAB> and <BS> -- 0 to disable
  vim.opt.expandtab      = true --> Use space instead of tab
  vim.opt.shiftwidth     = 2    --> Number of spaces to use for auto-indentation, <<, >>, etc.
  vim.opt.shiftround     = true --> Make the indentation to a multiple of shiftwidth when using < or >

  -- Location in the buffer
  vim.opt.number         = true
  vim.opt.relativenumber = true
  vim.opt.cursorline     = true
  vim.opt.cursorlineopt  = "number" --> line, screenline, both (i.e., "number,line")
  vim.opt.cursorcolumn   = true

  -- Search and replace
  vim.opt.ignorecase     = true    --> Ignore case in search
  vim.opt.smartcase      = true    --> /smartcase -> apply ignorecase | /sMartcase -> do not apply ignorecase
  vim.opt.inccommand     = "split" --> show the substitution in a split window

  -- Split
  vim.opt.splitright     = true --> Vertical split created right
  vim.opt.splitbelow     = true --> Horizontal split created below

  -- UI
  vim.opt.signcolumn     = "yes" --> Render signcolumn always to prevent text shifting
  vim.opt.scrolloff      = 7     --> Keep minimum x number of screen lines above and below the cursor
  vim.opt.termguicolors  = true  --> Enables 24-bit RGB color in the TUI
  vim.opt.showtabline    = 2     --> 0: never, 1: >= 2 tabs, 2: always
  vim.opt.laststatus     = 2     --> 0: never, 1: >= 2 windows, 2: always, 3: always and have one global statusline

  -- Char rendering
  vim.opt.list           = true --> Render special char in listchars
  vim.opt.listchars      = { tab = "⇥ ", trail = "␣", nbsp = "⍽", leadmultispace = "┊ ", }
  vim.opt.showbreak      = "↪" --> Render beginning of wrapped lines
  vim.opt.breakindent    = true --> Wrapped line will have the same indentation level as the beginning of the line

  -- Spell
  vim.opt.spell          = false    --> autocmd will enable spellcheck in Tex or markdown
  vim.opt.spelllang      = { "en" }
  vim.opt.spellsuggest   = "best,8" --> Suggest 8 words for spell suggestion
  vim.opt.spelloptions   = "camel"  --> Consider CamelCase when checking spelling

  -- Fold
  vim.opt.foldenable     = false                        --> Open all folds until I close them using zc/zC or update using zx
  vim.opt.foldmethod     = "expr"                       --> Use `foldexpr` function for folding
  vim.opt.foldexpr       = "nvim_treesitter#foldexpr()" --> Treesitter folding
  --foldlevel      = 2                            --> Ignore n - 1 level fold

  -- Update time
  vim.opt.updatetime     = 250
  vim.opt.timeoutlen     = 300

  -- Window size
  vim.opt.winminwidth    = 3

  -- Others
  vim.opt.mouse          = "a"
  vim.opt.confirm        = true --> Confirm before exiting with unsaved bufffer(s)
end

return M
