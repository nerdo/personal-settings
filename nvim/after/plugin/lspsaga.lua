local present, lspsaga = pcall(require, "lspsaga")

if not present then
	return
end

lspsaga.setup({
	finder = {
		keys = {
			toggle_or_open = "<CR>",
			vsplit = "|",
			split = "-",
			quit = { "q", "<esc>", "<C-c>" },
		},
	},
	rename = {
		keys = {
			quit = { "q", "<esc>", "<C-c>" },
		}
	},
	code_action = {
		keys = {
			quit = { "q", "<esc>", "<C-c>" },
		},
	},
	diagnostic = {
		keys = {
			quit = { "q", "<esc>", "<C-c>" },
		},
	},
	hover = {
		open_browser = "!firefox",
	},
	ui = {
		border = "solid",
	},
})

-- Keymaps are set in mason.
