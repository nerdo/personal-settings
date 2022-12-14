local present, bufdel = pcall(require, "bufdel")

if not present then
	return
end

bufdel.setup({
	quit = false,
})

local nerdo = require("nerdo.functions")

-- Close splits, or when there is only one, close buffers.
vim.keymap.set("n", "<leader><BS>", function()
	-- Workaround for vim quitting when closing a buffer and Trouble is open.
	local trouble_was_open = nerdo.editor.buffer_filetype_is_open("Trouble")
	if trouble_was_open then
		vim.cmd("TroubleToggle")
	end

	nerdo.editor.win_or_buf("close", "BufDel")

	if trouble_was_open then
		vim.cmd("TroubleToggle")
		vim.cmd("bp")
	end
end)

-- Just close the buffer.
vim.keymap.set("n", "\\<BS>", function()
	local trouble_was_open = nerdo.editor.buffer_filetype_is_open("Trouble")
	if trouble_was_open then
		vim.cmd("TroubleToggle")
	end

	nerdo.editor.win_or_buf("BufDel", "BufDel")

	if trouble_was_open then
		vim.cmd("TroubleToggle")
		vim.cmd("bp")
	end
end)
