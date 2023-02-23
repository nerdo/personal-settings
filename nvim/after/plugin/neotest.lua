local present, neotest = pcall(require, "neotest")

if not present or vim.g.vscode then
	return
end

neotest.setup({
	adapters = {
		require("neotest-rust"),
		require("neotest-phpunit")({
			phpunit_cmd = function()
				return "vendor/bin/phpunit"
			end,
		}),
		require("neotest-vitest"),
		require("neotest-jest"),
	},
})

vim.keymap.set("n", "<leader>th", function()
	neotest.summary.toggle()
end)
vim.keymap.set({ "n", "i" }, "<M-t>", function()
	-- Run single test.
	neotest.run.run()
end)
vim.keymap.set({ "n", "i" }, "<C-t>", function()
	-- Run entire file.
	neotest.run.run(vim.fn.expand("%"))
end)
vim.keymap.set("n", "<leader>dt", function()
	neotest.run.run({ strategy = "dap" })
end)
vim.keymap.set("n", "<leader>to", function()
	neotest.output.open()
end)
vim.keymap.set("n", "<leader>tO", function()
	neotest.output_panel.toggle()
end)
