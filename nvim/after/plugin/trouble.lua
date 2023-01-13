local present, trouble = pcall(require, "trouble")

if not present or vim.g.vscode then
	return
end

-- Start some trouble hehe...
trouble.setup({
	position = "top",
	padding = false,
	use_diagnostic_signs = true,
	auto_preview = false,
})

-- Set keymaps.
vim.keymap.set("n", "<leader>ii", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>iw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>id", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>il", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>iQ", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })

local nerdo = require("nerdo.functions")

vim.api.nvim_create_autocmd("BufEnter", {
	group = nerdo.augroup,
	pattern = "*",
	callback = function()
		if nerdo.trouble_auto_leave.get() == false then
			nerdo.trouble_auto_leave.set(true)
			return
		end

		local file_type = vim.bo.filetype
		if file_type ~= "Trouble" then
			return
		end

		local last_normal_focused_bufnr = nerdo.last_normal_focused_bufnr()
		vim.schedule(function()
			vim.cmd("buffer " .. last_normal_focused_bufnr)
		end)
	end,
})

-- This keymap runs a function that toggles Trouble open but retains focus on the current buffer (by going back to the previous buffer immediately).
vim.keymap.set("n", "<leader>io", function()
	vim.cmd("TroubleToggle")
end)

-- This keymap runs a function that toggles Trouble open but retains focus on the current buffer (by going back to the previous buffer immediately).
vim.keymap.set("n", "<leader>iq", function()
	vim.cmd("TroubleToggle quickfix")
end)
