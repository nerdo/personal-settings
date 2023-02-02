local nerdo = require("nerdo.functions")

-- Set php comment string.
vim.api.nvim_create_autocmd("FileType", {
	group = nerdo.augroup,
	pattern = "php",
	command = "setlocal commentstring=//\\ %s",
})
