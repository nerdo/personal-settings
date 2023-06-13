local present, lspsaga = pcall(require, "lspsaga")

if not present then
	return
end

lspsaga.setup({
	finder = {
		keys = {
			jump_to = "<leader><leader>",
			expand_or_jump = "<CR>",
			vsplit = "|",
			split = "-",
		},
	},
	hover = {
		open_browser = "!firefox",
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
	ui = {
		border = "solid",
	},
})

-- Keymaps are set in lsp.
