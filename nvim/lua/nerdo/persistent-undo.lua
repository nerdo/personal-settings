local undo_history_path = vim.fn.stdpath("data") .. "/undo-history/"
if not vim.fn.isdirectory(undo_history_path) then
	vim.api.nvim_command("!mkdir -p " .. undo_history_path)
end
vim.o.undodir = undo_history_path
vim.o.undofile = true
