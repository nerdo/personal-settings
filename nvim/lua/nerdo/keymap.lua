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

-- Helper function to add descriptions while keeping opts
local function with_desc(description)
	return vim.tbl_extend("force", opts, { desc = description })
end

-- Quitting - wipe terminal buffers first to avoid stuck-window issues.
local function close_terminal_buffers()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end
local function smart_quit(save)
	local buf = vim.api.nvim_get_current_buf()
	if vim.bo[buf].buftype == "terminal" then
		vim.api.nvim_buf_delete(buf, { force = true })
		return
	end
	vim.cmd(save and "x" or "q!")
end
local function quit_all(save)
	close_terminal_buffers()
	vim.cmd(save and "wqa" or "qa!")
end
vim.keymap.set("n", "ZZ", function() smart_quit(true) end, with_desc("Save and quit"))
vim.keymap.set("n", "ZQ", function() smart_quit(false) end, with_desc("Force quit"))
vim.keymap.set("n", "XX", function() quit_all(true) end, with_desc("Save and quit all"))
vim.keymap.set("n", "XQ", function() quit_all(false) end, with_desc("Force quit all"))

-- Save file.
vim.keymap.set("n", ";;", save_buffer, with_desc("Save buffer"))

-- Close buffer.
vim.keymap.set("n", "<leader>c", function() require("nerdo.functions").editor.smart_buffer_close() end,
	with_desc("Smart close buffer"))
vim.keymap.set("n", "<leader>C", function()
	-- https://github.com/neovim/neovim/issues/2434#issuecomment-93434827
	vim.cmd("set bufhidden=delete")
	vim.cmd("bnext")
end, with_desc("Delete buffer and go to next"))

-- Kill search highlights.
vim.keymap.set("n", "<leader>/", ":noh<cr>", with_desc("Clear search highlights"))

-- New buffer.
vim.keymap.set("n", "<leader>b", "<Cmd>enew<CR>", with_desc("New buffer"))

-- Tab through buffers.
vim.keymap.set("n", "<Tab>", "<Cmd>bn<CR>", with_desc("Next buffer"))
vim.keymap.set("n", "<S-Tab>", "<Cmd>bp<CR>", with_desc("Previous buffer"))

-- Path functions.
vim.keymap.set("n", "<leader>yr", "<Cmd>NerdoCpRelPath<CR>", with_desc("Copy relative path"))
vim.keymap.set("n", "<leader>ya", "<Cmd>NerdoCpAbsPath<CR>", with_desc("Copy absolute path"))
vim.keymap.set("n", "<leader>%r", "<Cmd>NerdoShowRelPath<CR>", with_desc("Show relative path"))
vim.keymap.set("n", "<leader>%a", "<Cmd>NerdoShowAbsPath<CR>", with_desc("Show absolute path"))

-- Line number functions.
vim.keymap.set("n", "<leader>1", "<Cmd>NerdoCycleLineNr<CR>", with_desc("Cycle line number mode"))
vim.keymap.set("n", "<leader>2", "<Cmd>NerdoSetLineNrCustom<CR>", with_desc("Set custom line numbers"))
vim.keymap.set("n", "<leader>3", "<Cmd>NerdoSetLineNrRelative<CR>", with_desc("Set relative line numbers"))
vim.keymap.set("n", "<leader>4", "<Cmd>NerdoSetLineNrAbsolute<CR>", with_desc("Set absolute line numbers"))

local nerdo = require("nerdo.functions")

-- Split navigation with Alt+nav keys.
vim.keymap.set("n", "<A-h>", function()
	nerdo.trouble_auto_leave.set(false)
	vim.cmd("wincmd h")
end, with_desc("Navigate to left window"))
vim.keymap.set("n", "<A-j>", function()
	nerdo.trouble_auto_leave.set(false)
	vim.cmd("wincmd j")
end, with_desc("Navigate to bottom window"))
vim.keymap.set("n", "<A-k>", function()
	nerdo.trouble_auto_leave.set(false)
	vim.cmd("wincmd k")
end, with_desc("Navigate to top window"))
vim.keymap.set("n", "<A-l>", function()
	nerdo.trouble_auto_leave.set(false)
	vim.cmd("wincmd l")
end, with_desc("Navigate to right window"))

-- Split resizing with Ctrl+Alt+nav keys.
vim.keymap.set("n", "<C-A-h>", "<Cmd>vertical resize -1<CR>", with_desc("Decrease window width"))
vim.keymap.set("n", "<C-A-j>", "<Cmd>resize -1<CR>", with_desc("Decrease window height"))
vim.keymap.set("n", "<C-A-k>", "<Cmd>resize +1<CR>", with_desc("Increase window height"))
vim.keymap.set("n", "<C-A-l>", "<Cmd>vertical resize +1<CR>", with_desc("Increase window width"))

-- theprimagen's awesome visual move text keymap.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", with_desc("Move selected lines down"))
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", with_desc("Move selected lines up"))

-- nerdo's keymaps
vim.keymap.set("i", "<F9>", "<Esc>I", with_desc("Exit insert and go to beginning of line"))
vim.keymap.set("i", "<F10>", "<Esc>A", with_desc("Exit insert and go to end of line"))

-- escape in terminal mode
vim.keymap.set('t', '<M-Esc>', '<C-\\><C-n>', { desc = 'Exit insert mode in terminal' })
