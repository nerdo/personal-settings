local present, inlayhints = pcall(require, "lsp-inlayhints")

if not present then
	return
end

inlayhints.setup({
	enabled_at_startup = false,
})

vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
	group = "LspAttach_inlayhints",
	callback = function(args)
		if not (args.data and args.data.client_id) then
			return
		end

		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		inlayhints.on_attach(client, bufnr)
	end,
})

-- Toggles inlay hints.
vim.keymap.set("n", "<leader>ih", function()
	inlayhints.toggle()
end)
