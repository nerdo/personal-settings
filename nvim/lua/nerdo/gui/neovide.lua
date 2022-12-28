if vim.g.neovide == false then
	return
end

vim.g.neovide_transparency = 0.85
vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_remember_window_size = false
vim.g.neovide_cursor_vfx_mode = "ripple"
vim.g.neovide_floating_opacity = 0.9
vim.g.neovide_hide_mouse_when_typing = true

require("nerdo.gui.neovide-font-sizing")

-- https://github.com/neovide/neovide/issues/1263#issuecomment-1100895622
-- Allow clipboard copy paste in neovim
vim.g.neovide_input_use_logo = 1
vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
