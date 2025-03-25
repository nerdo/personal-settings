-- Default vi key bindings: https://hea-www.harvard.edu/~fine/Tech/vi.html (try to preserve these...)
-- Set leader.
vim.g.mapleader = ","

-- Save buffer.
-- Note: these two do the same thing by default, but in a buffer where a language server is present,
-- <leader>; will format the buffer before saving. <leader>w will not.
local function save_buffer()
	if vim.g.vscode then
		vim.cmd("call VSCodeCall('workbench.action.files.save')")
	else
		vim.cmd("write")
	end
end

local opts = { silent = true }

-- Quitting
vim.keymap.set("n", "XQ", "<Cmd>qa!<CR>", opts)
vim.keymap.set("n", "XX", "<Cmd>wqa<CR>", opts)

-- Save file.
vim.keymap.set("n", ";;", save_buffer, opts)

-- Close buffer.
vim.keymap.set("n", "<leader>c", "<Cmd>bd!<CR>")
vim.keymap.set("n", "<leader>C", function()
	-- https://github.com/neovim/neovim/issues/2434#issuecomment-93434827
	vim.cmd("set bufhidden=delete")
	vim.cmd("bnext")
end, opts)

-- Kill search highlights.
vim.keymap.set("n", "<leader>/", ":noh<cr>", opts)

-- New buffer.
vim.keymap.set("n", "<leader>b", "<Cmd>enew<CR>", opts)

-- Tab through buffers.
vim.keymap.set("n", "<Tab>", "<Cmd>bn<CR>", opts)
vim.keymap.set("n", "<S-Tab>", "<Cmd>bp<CR>", opts)

-- Path functions.
vim.keymap.set("n", "<leader>yr", "<Cmd>NerdoCpRelPath<CR>", opts)
vim.keymap.set("n", "<leader>ya", "<Cmd>NerdoCpAbsPath<CR>", opts)
vim.keymap.set("n", "<leader>%r", "<Cmd>NerdoShowRelPath<CR>", opts)
vim.keymap.set("n", "<leader>%a", "<Cmd>NerdoShowAbsPath<CR>", opts)

-- Line number functions.
vim.keymap.set("n", "<leader>1", "<Cmd>NerdoCycleLineNr<CR>", opts) -- A shortcut for cycling line number settings.
vim.keymap.set("n", "<leader>2", "<Cmd>NerdoSetLineNrCustom<CR>", opts)
vim.keymap.set("n", "<leader>3", "<Cmd>NerdoSetLineNrRelative<CR>", opts)
vim.keymap.set("n", "<leader>4", "<Cmd>NerdoSetLineNrAbsolute<CR>", opts)

local nerdo = require("nerdo.functions")

-- Split navigation with Alt+nav keys.
vim.keymap.set("n", "<A-h>", function()
	nerdo.trouble_auto_leave.set(false)
	vim.cmd("wincmd h")
end)
vim.keymap.set("n", "<A-j>", function()
	nerdo.trouble_auto_leave.set(false)
	vim.cmd("wincmd j")
end)
vim.keymap.set("n", "<A-k>", function()
	nerdo.trouble_auto_leave.set(false)
	vim.cmd("wincmd k")
end)
vim.keymap.set("n", "<A-l>", function()
	nerdo.trouble_auto_leave.set(false)
	vim.cmd("wincmd l")
end)

-- Split resizing with Alt+Shift+nav keys.
vim.keymap.set("n", "<A-S-h>", "<Cmd>vertical resize -1<CR>", opts)
vim.keymap.set("n", "<A-S-j>", "<Cmd>resize -1<CR>", opts)
vim.keymap.set("n", "<A-S-k>", "<Cmd>resize +1<CR>", opts)
vim.keymap.set("n", "<A-S-l>", "<Cmd>vertical resize +1<CR>", opts)

-- theprimagen's awesome visual move text keymap.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- nerdo's keymaps
vim.keymap.set("i", "<F9>", "<Esc>I", opts)
vim.keymap.set("i", "<F10>", "<Esc>A", opts)
