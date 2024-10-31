if not vim.g.vscode then
  return {}
end

vim.opt.linespace = 0
vim.opt.guifont = "JetBrainsMono Nerd Font:h20:#e-antialias:#h-none"

vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_refresh_rate = 144

vim.g.neovide_cursor_animation_length = 0.05

return {}
