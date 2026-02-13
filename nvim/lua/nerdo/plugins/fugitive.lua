-- Git tools.
return {
	"tpope/vim-fugitive",
	config = function()
		-- Set a dummy winbar on fugitive blame and diff windows so they align
		-- with the source window's lspsaga breadcrumb winbar (prevents off-by-1).
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "fugitiveblame",
			callback = function()
				vim.wo.winbar = " "
			end,
		})
		vim.api.nvim_create_autocmd("BufWinEnter", {
			callback = function()
				local bufname = vim.api.nvim_buf_get_name(0)
				if bufname:match("^fugitive://") then
					vim.wo.winbar = " "
				end
			end,
		})
	end,
}
