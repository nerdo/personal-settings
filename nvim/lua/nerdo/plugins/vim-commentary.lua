-- Comment out lines with keymap.
return {
	"tpope/vim-commentary",
	config = function()
		local nerdo = require("nerdo.functions")

		-- Disable auto adding comment string when enter is pressed or o/O in normal modes
		-- https://superuser.com/a/271024/1174441
		vim.api.nvim_create_autocmd("FileType", {
			group = nerdo.augroup,
			pattern = "*",
			callback = function()
				vim.opt.formatoptions = string.gsub(vim.o.formatoptions, "[ro]", "")
			end,
		})

		-- Set php comment string.
		vim.api.nvim_create_autocmd("FileType", {
			group = nerdo.augroup,
			pattern = "php",
			command = "setlocal commentstring=//\\ %s",
		})
	end
}
