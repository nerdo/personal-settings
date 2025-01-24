-- Replace UI for messages, cmdline, popupmenu.
if vim.g.nerdo_is_headless then
	return {}
end

return {
	"folke/noice.nvim",
	enabled = false,
	event = "VeryLazy",
	dependencies = "MunifTanjim/nui.nvim",
	config = function()
		local noice = require("noice")
		local lsp_signature_is_present, _ = pcall(require, "lsp_signature")

		local signature_enabled = true
		if lsp_signature_is_present then
			signature_enabled = false
		end

		noice.setup({
			cmdline = {
				view = "cmdline",
			},
			lsp = {
				signature = {
					enabled = signature_enabled,
				},

				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = false, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		})
	end,
}
