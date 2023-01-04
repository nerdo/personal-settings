-- Centers the cursor on the screen.
vim.opt.scrolloff = 999

-- Sets relative line numbering.
vim.opt.number = true
vim.opt.relativenumber = true

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
