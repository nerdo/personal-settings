-- Centers the cursor on the screen (when not running headless)
if not vim.g.nerdo_is_headless then
	vim.opt.scrolloff = 999
end

-- Gives horizontal scrolling some breathing room
vim.opt.sidescrolloff = 20

-- Sets relative line numbering.
require("nerdo.functions").line_numbers.refresh()

-- Turn off line wrapping
vim.opt.wrap = false

-- Set line numbers in netrw
vim.g.netrw_bufsettings = "number relativenumber nowrap"

-- Always keep gutter open.
vim.opt.signcolumn = "yes"

-- Turn on cursor line.
vim.opt.cursorline = true
vim.opt.cursorlineopt = "line,number"

-- Turn on true color.
vim.opt.termguicolors = true

-- Turn off the mouse.
vim.opt.mouse = ""

-- Default tabstop/shift width.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Create splits to the right and below by default.
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Set PHP file comments
vim.api.nvim_create_autocmd("FileType", {
	pattern = "php",
	callback = function()
		vim.bo.commentstring = "// %s"
	end,
})
