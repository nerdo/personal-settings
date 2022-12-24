local present, dap = pcall(require, "dap")

if not present then
	return
end

-- Set up signs for dap.
vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "🔶", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "⛔️", texthl = "", linehl = "", numhl = "" })

-- Set up debugging keymaps.
vim.keymap.set("n", "<F5>", function()
	dap.continue()
end)
vim.keymap.set("n", "<F8>", function()
	dap.step_out()
end)
vim.keymap.set("n", "<F9>", function()
	dap.step_into()
end)
vim.keymap.set("n", "<F10>", function()
	dap.step_over()
end)
vim.keymap.set("n", "<leader>db", function()
	dap.toggle_breakpoint()
end)
vim.keymap.set("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
vim.keymap.set("n", "<leader>dl", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
vim.keymap.set("n", "<leader>dr", function()
	dap.repl.open()
end)
vim.keymap.set("n", "<leader>dR", function()
	dap.run_last()
end)
