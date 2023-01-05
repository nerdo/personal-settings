local present, toggleterm = pcall(require, "toggleterm")

if not present then
	return
end

toggleterm.setup({
	-- Dynamic sizing function based on terminal direction.
	size = function(term)
		if term.direction == "horizontal" then
			return math.max(20, vim.api.nvim_win_get_height(0) * 0.2)
		elseif term.direction == "vertical" then
			return math.max(50, vim.o.columns * 0.35)
		else
			return 100
		end
	end,

	float_opts = {
		border = "single",
	},

	highlights = {
		NormalFloat = {
			guibg = "#1f2022",
		},
		FloatBorder = {
			guibg = "#1f2022",
			guifg = "#1f2022",
		},
	},
})

-- Set up some keybindings just for the terminal buffer.
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*",
	callback = function()
		local opts = { buffer = 0 }
		vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "<A-o>", "<Cmd>1ToggleTerm direction=float<CR>", opts)
		vim.keymap.set("t", "<A-r>", "<Cmd>2ToggleTerm direction=vertical<CR>", opts)
		vim.keymap.set("t", "<A-b>", "<Cmd>3ToggleTerm direction=horizontal<CR>", opts)
	end,
})

-- Set some keymaps.
vim.keymap.set({ "n", "i", "v" }, "<A-o>", "<Cmd>1ToggleTerm direction=float<CR>")
vim.keymap.set({ "n", "i", "v" }, "<A-r>", "<Cmd>2ToggleTerm direction=vertical<CR>")
vim.keymap.set({ "n", "i", "v" }, "<A-b>", "<Cmd>3ToggleTerm direction=horizontal<CR>")
