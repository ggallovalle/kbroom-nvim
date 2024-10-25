local M = {}

function M.setup()
  -- {{{ diagnostic
  -- Diagnostic appearance
  vim.diagnostic.config({
    float = {
      border = "rounded",
      format = function(diagnostic)
        -- "ERROR (line n): message"
        return string.format("%s (line %i): %s",
          vim.diagnostic.severity[diagnostic.severity],
          diagnostic.lnum + 1,
          diagnostic.message)
      end
    },
    update_in_insert = false,
  })

  -- Keymaps
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
  -- }}}
end

return M
