local M = {}

-- Toggle quickfix list
function M.toggle()
	local qf_exists = false
	for _, win in pairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then
			qf_exists = true
		end
	end
	if qf_exists then
		vim.cmd("cclose")
	else
		vim.cmd("copen")
	end
end

-- Setup keymaps
function M.setup()
	local opts = { silent = true }
	vim.keymap.set("n", "<leader>q", M.toggle, opts)
	
	-- Auto-close quickfix when opening an entry
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "qf",
		callback = function()
			vim.keymap.set("n", "<CR>", "<CR><Cmd>cclose<CR>", { buffer = true, silent = true })
		end,
	})
end

return M