-- Debug adapter.
return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio"
	},
	enabled = function()
		return not vim.g.vscode
	end,
	config = function()
		local dapui = require("dapui")

		dapui.setup()

		-- Auto open/close the dap ui when debugging is in progress/completed.
		local dap_present, dap = pcall(require, "dap")
		if dap_present then
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end
	end,
}
