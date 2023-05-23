local present, inlayhints = pcall(require, "lsp-inlayhints")

if not present or vim.g.vscode then
	return
end

inlayhints.setup({
	enabled_at_startup = false,
	inlay_hints = {
		parameter_hints = {
			prefix = "<- ",
			remove_colon_start = true,
			remove_colon_end = true,
		},
		type_hints = {
			prefix = "=> ",
			remove_colon_start = true,
			remove_colon_end = true,
		},
	},
})

local nerdo = require("nerdo.functions")
vim.api.nvim_create_autocmd("LspAttach", {
	group = nerdo.augroup,
	callback = function(args)
		if not (args.data and args.data.client_id) then
			return
		end

		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		inlayhints.on_attach(client, bufnr, false)
	end,
})

-- Toggles inlay hints.
vim.keymap.set("n", "<leader>ih", function()
	inlayhints.toggle()
end)

-- Highlight color.
-- https://colorcodes.io is a great starting point...
-- Lavender on a brighter shade of Midnight Purple...
vim.api.nvim_set_hl(0, "LspInlayHint", { bg = "#371f54", fg = "#dba6f7", bold = true })
