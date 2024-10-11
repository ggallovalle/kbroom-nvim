--- statusline.lua
--- $ figlet -f stacey theovim
--- ________________________________ _________________
--- 7      77  7  77     77     77  V  77  77        7
--- !__  __!|  !  ||  ___!|  7  ||  |  ||  ||  _  _  |
---   7  7  |     ||  __|_|  |  ||  !  ||  ||  7  7  |
---   |  |  |  7  ||     7|  !  ||     ||  ||  |  |  |
---   !__!  !__!__!!_____!!_____!!_____!!__!!__!__!__!
---
--- Provide functions to build a Lua table and Luaeval string used for setting up Vim statusline

Statusline = {}


Statusline.isNormalBuffer = function()
  return vim.bo.buftype == ""
end


Statusline.getMode = function()
  local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
  local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)
  local modesTable = {
    ["n"] = { name = "N", hl = "%#MiniStatuslineModeNormal#" },
    ["v"] = { name = "V", hl = "%#MiniStatuslineModeVisual#" },
    ["V"] = { name = "V-LINE", hl = "%#MiniStatuslineModeVisual#" },
    [CTRL_V] = { name = "V-BLOCK", hl = "%#MiniStatuslineModeVisual#" },
    ["s"] = { name = "SEL", hl = "%#MiniStatuslineModeVisual#" },
    ["S"] = { name = "SEL-LINE", hl = "%#MiniStatuslineModeVisual#" },
    [CTRL_S] = { name = "SEL-BLOCK", hl = "%#MiniStatuslineModeVisual#" },
    ["i"] = { name = "I", hl = "%#MiniStatuslineModeInsert#" },
    ["R"] = { name = "R", hl = "%#MiniStatuslineModeReplace#" },
    ["c"] = { name = "CMD", hl = "%#MiniStatuslineModeCommand#" },
    ["r"] = { name = "PROMPT", hl = "%#MiniStatuslineModeOther#" },
    ["!"] = { name = "SH", hl = "%#MiniStatuslineModeOther#" },
    ["t"] = { name = "TERM", hl = "%#MiniStatuslineModeOther#" },
  }

  -- set a default option via metatable
  local modes = setmetatable(modesTable, {
    __index = function()
      return { name = "Unknown", hl = "%#MiniStatuslineModeOther#" }
    end
  })

  return modes[vim.fn.mode()]
end


Statusline.getGit = function()
  if not Statusline.isNormalBuffer() then return "" end

  local head = vim.b.gitsigns_head or "-"
  local signs = vim.b.gitsigns_status or ""
  local icon = vim.g.have_nerd_font and "" or "GIT:"

  if signs == "" then
    if head == "-" or head == "" then return "" end
    return string.format(" %s %s ", icon, head)
  end
  return string.format(" %s %s %s ", icon, head, signs)
end


Statusline.getDiagnostics = function()
  if not Statusline.isNormalBuffer() then return "" end

  local str = ""

  local diagnosticLevels = {
    e = vim.diagnostic.severity.ERROR,
    w = vim.diagnostic.severity.WARN,
    i = vim.diagnostic.severity.INFO,
    h = vim.diagnostic.severity.HINT,
  }

  local count = {}
  for name, id in pairs(diagnosticLevels) do
    count[name] = #vim.diagnostic.get(0, { severity = id })
  end

  if count.e > 0 then
    str = str .. " E: " .. count.e
  end
  if count.w > 0 then
    str = str .. " H: " .. count.w
  end
  if count.i > 0 then
    str = str .. " I: " .. count.i
  end
  if count.h > 0 then
    str = str .. " W: " .. count.e
  end

  return (str ~= "" and str .. " " or "")
end


-- Short statusline:
-- [Mode] filename.txt[mod][RO] diagnostic git      line : col
-- Long statusline:
-- [Mode] path/filename.txt[mod][RO] diagnostic git      filetype ff enc line/total : col/total
Statusline.getActiveStatusline = function()
  local modeInfo = Statusline.getMode()
  --local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  local filemodifier = "%m%r "

  local curWidth = vim.o.laststatus == 3 and vim.o.columns or vim.api.nvim_win_get_width(0)
  local isShort = (curWidth < 100)
  if isShort then
    local location = " %l:%v "

    return table.concat({
      modeInfo.hl,
      " ",
      modeInfo.name,
      " ",
      "%#MiniStatuslineFilename#",
      " %t", --> tail
      filemodifier,
      "%#MiniStatuslineInactive#",
      "%=", --> spacer
      modeInfo.hl,
      location,
    })
  end

  local ff = vim.bo.fileformat
  -- If new file does not have encoding, display global encoding
  local enc = (vim.bo.fileencoding == "") and (vim.o.encoding) or (vim.bo.fileencoding)
  local fileInfo = string.format(" %%Y | %s | %s ", ff:upper(), enc:upper())
  local location = ' %l/%L:%2v/%-2{virtcol("$") - 1} '
  local diagnostics = Statusline.getDiagnostics()
  local git = Statusline.getGit()

  return table.concat({
    modeInfo.hl,
    " ",
    modeInfo.name,
    " ",
    "%#MiniStatuslineFilename#",
    " %t", --> tail
    filemodifier,
    "%#MiniStatuslineDevinfo#",
    diagnostics,
    git,
    "%#MiniStatuslineInactive#",
    "%=", --> spacer
    "%#MiniStatuslineFilename#",
    fileInfo,
    modeInfo.hl,
    location,
  })
end


Statusline.getInactiveStatusline = function()
  return "%#MiniStatuslineFilename# %t%m%r %#MiniStatuslineInactive#%=%< %#MiniStatuslineFileinfo# %l:%v "
end


Statusline.setup = function()
  -- Safeguard
  vim.opt.statusline = "%{%v:lua.Statusline.active()%}"

  local statusline_augroup = vim.api.nvim_create_augroup("Statusline", {})
  vim.api.nvim_create_autocmd(
    { "WinEnter", "BufEnter", },
    {
      group = statusline_augroup,
      pattern = "*",
      callback = function()
        vim.wo.statusline = "%!v:lua.Statusline.getActiveStatusline()"
      end,
      desc = "Set active Statusline"
    })
  vim.api.nvim_create_autocmd(
    { "WinLeave", "BufLeave", },
    {
      group = statusline_augroup,
      pattern = "*",
      callback = function()
        -- No need for eval since inactive Statusline is a simple string
        vim.wo.statusline = Statusline.getInactiveStatusline()
      end,
      desc = "Set inactive Statusline"
    })
end

return Statusline
