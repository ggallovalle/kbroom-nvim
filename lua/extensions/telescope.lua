local builtin = require("telescope.builtin")

local M = {}

-- NOTE: this doesn't work, the api for builtin.quickfix is different than expected
M.diagnostics_with_sources = function()
    local diagnostics = vim.diagnostic.get(0)
    local results = {}
    for _, diagnostic in ipairs(diagnostics) do
      local client_name = vim.lsp.get_client_by_id(diagnostic.source).name
      table.insert(results, {
        filename = vim.api.nvim_buf_get_name(0),
        lnum = diagnostic.lnum + 1,
        col = diagnostic.col + 1,
        text = diagnostic.message .. " (from " .. client_name .. ")",
      })
    end
    builtin.quickfix({
      title = "Diagnostics with LSP sources",
      items = results,
    })
end

return M