local present, rt = pcall(require, "rust-tools")

if not present then
	return
end

rt.setup({
	server = {
		on_attach = function(_, bufnr)
			local opts = { buffer = bufnr }
			vim.keymap.set("n", "<leader>la", function()
				rt.hover_actions.hover_actions()
			end, opts)
			vim.keymap.set("n", "<leader>lR", function()
				rt.runnables.runnables()
			end, opts)
		end,
	},
})
