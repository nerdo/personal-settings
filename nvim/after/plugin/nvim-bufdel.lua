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
	nerdo.editor.win_or_buf("close", "BufDel")
end)

-- Just close the buffer.
vim.keymap.set("n", "\\<BS>", function()
	nerdo.editor.win_or_buf("BufDel", "BufDel")
end)
