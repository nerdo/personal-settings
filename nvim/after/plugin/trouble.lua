local present, trouble = pcall(require, "trouble")

if not present then
	return
end

-- Start some trouble hehe...
trouble.setup({
	position = "top",
})

-- Set keymaps.
vim.keymap.set("n", "<leader>ii", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>iw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>id", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>il", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>iq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })

local nerdo = require("nerdo.functions")

-- This keymap runs a function that toggles Trouble open but retains focus on the current buffer (by going back to the previous buffer immediately).
vim.keymap.set("n", "<leader>io", function()
	local trouble_was_open = nerdo.editor.buffer_filetype_is_open("Trouble")

	-- Assuming opening Trouble happens synchronously...
	vim.cmd("TroubleToggle")

	-- This should work, assuming the above holds true...
	if not trouble_was_open then
		vim.cmd("bp")
	end
end)
