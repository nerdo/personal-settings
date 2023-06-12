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
