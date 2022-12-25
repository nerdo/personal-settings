-- Default vi key bindings: https://hea-www.harvard.edu/~fine/Tech/vi.html (try to preserve these...)

-- Set leader.
vim.g.mapleader = " "

-- Save buffer.
-- Note: these two do the same thing by default, but in a buffer where a language server is present,
-- <leader>; will format the buffer before saving. <leader>w will not.
vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>")
vim.keymap.set("n", "<leader>;", "<Cmd>w<CR>")

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

-- Split navigation with Alt+nav keys.
vim.keymap.set("n", "<A-h>", "<Cmd>wincmd h<CR>")
vim.keymap.set("n", "<A-j>", "<Cmd>wincmd j<CR>")
vim.keymap.set("n", "<A-k>", "<Cmd>wincmd k<CR>")
vim.keymap.set("n", "<A-l>", "<Cmd>wincmd l<CR>")

-- Split resizing with Alt+Shift+nav keys.
vim.keymap.set("n", "<A-S-h>", "<Cmd>vertical resize -1<CR>")
vim.keymap.set("n", "<A-S-j>", "<Cmd>resize +1<CR>")
vim.keymap.set("n", "<A-S-k>", "<Cmd>resize -1<CR>")
vim.keymap.set("n", "<A-S-l>", "<Cmd>vertical resize +1<CR>")

-- Close splits, or when there is only one, close buffers.
vim.keymap.set("n", "<leader><BS>", function()
	local win_numbers = vim.api.nvim_tabpage_list_wins(0)
	local num_focusable_windows = 0

	-- Check for focusable windows (treesitter context, for example, creates windows that aren't focusable).
	for i = 1, #win_numbers do
		if vim.api.nvim_win_get_config(win_numbers[i])["focusable"] then
			num_focusable_windows = num_focusable_windows + 1
		end

		if num_focusable_windows > 1 then
			vim.cmd("close")
			return
		end
	end

	-- Close the buffer instead.
	vim.cmd("bd")
end)

-- theprimagen's awesome visual move text keymap.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
