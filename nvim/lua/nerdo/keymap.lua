-- Default vi key bindings: https://hea-www.harvard.edu/~fine/Tech/vi.html (try to preserve these...)
-- Set leader.
vim.g.mapleader = " "

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

vim.keymap.set("n", "<leader>w", save_buffer)
vim.keymap.set("n", "<leader>;", save_buffer)

-- New buffer.
vim.keymap.set("n", "<leader>b", "<Cmd>enew<CR>")

-- Save/quit.
vim.keymap.set("n", "<leader>q", "<Cmd>qa<CR>")
vim.keymap.set("n", "<leader>x", "<Cmd>xa<CR>")

-- Tab through buffers.
vim.keymap.set("n", "<Tab>", "<Cmd>bn<CR>")
vim.keymap.set("n", "<S-Tab>", "<Cmd>bp<CR>")

-- Path functions.
vim.keymap.set("n", "<leader>yr", "<Cmd>NerdoCpRelPath<CR>")
vim.keymap.set("n", "<leader>ya", "<Cmd>NerdoCpAbsPath<CR>")
vim.keymap.set("n", "<leader>%r", "<Cmd>NerdoShowRelPath<CR>")
vim.keymap.set("n", "<leader>%a", "<Cmd>NerdoShowAbsPath<CR>")

-- Line number functions.
vim.keymap.set("n", "<leader>3", "<Cmd>NerdoToggleLineNr<CR>") -- A shortcut for toggling line numbers.
vim.keymap.set("n", "<leader>##", "<Cmd>NerdoToggleLineNr<CR>")
vim.keymap.set("n", "<leader>#r", "<Cmd>NerdoSetLineNrRelative<CR>")
vim.keymap.set("n", "<leader>#a", "<Cmd>NerdoSetLineNrAbsolute<CR>")

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
vim.keymap.set("n", "<A-S-h>", "<Cmd>vertical resize -1<CR>")
vim.keymap.set("n", "<A-S-j>", "<Cmd>resize -1<CR>")
vim.keymap.set("n", "<A-S-k>", "<Cmd>resize +1<CR>")
vim.keymap.set("n", "<A-S-l>", "<Cmd>vertical resize +1<CR>")

-- theprimagen's awesome visual move text keymap.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
