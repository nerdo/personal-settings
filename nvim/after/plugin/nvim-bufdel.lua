local present, bufdel = pcall(require, "bufdel")

if not present or vim.g.vscode then
	return
end

bufdel.setup({
	quit = false,
})

local nerdo = require("nerdo.functions")

local close_generic = function()
	-- Workaround for vim quitting when closing a buffer and Trouble is open.
	local trouble_was_open = nerdo.editor.buffer_filetype_is_open("Trouble")
	if trouble_was_open then
		vim.cmd("TroubleToggle")
	end

	nerdo.editor.win_or_buf("close", "BufDel")

	if trouble_was_open then
		vim.cmd("TroubleToggle")
		vim.api.nvim_set_current_buf(nerdo.editor.last_normal_focused_bufnr())
	end
end

local close_buffer = function()
	local trouble_was_open = nerdo.editor.buffer_filetype_is_open("Trouble")
	if trouble_was_open then
		vim.cmd("TroubleToggle")
	end

	nerdo.editor.win_or_buf("BufDel", "BufDel")

	if trouble_was_open then
		vim.cmd("TroubleToggle")
		vim.api.nvim_set_current_buf(nerdo.editor.last_normal_focused_bufnr())
	end
end

-- Close splits, or when there is only one, close buffers.
vim.keymap.set("n", "<leader>\\", close_generic)

-- Just close the buffer.
vim.keymap.set("n", "<leader>c", close_buffer)
