local M = {}

function M.setup()
  if vim.g.neovide then
    local padding = 10
    vim.g.neovide_padding_top = padding
    vim.g.neovide_padding_bottom = padding
    vim.g.neovide_padding_right = padding
    vim.g.neovide_padding_left = padding

    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_cursor_vfx_mode = "railgun"

    vim.g.neovide_transparency = 0.69
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
  end
end

return M
