-- Go to the next highest buffer when a buffer is deleted.
vim.api.nvim_create_autocmd("BufDelete", {
	pattern = "#",
	callback = function()
		local highest_bufnr = vim.cmd.bufnr("$")
		local current_bufnr = vim.cmd.bufnr("%")
		if current_bufnr < highest_bufnr then
			vim.cmd("bnext")
		end
	end,
})
