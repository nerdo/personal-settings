local present, dapui = pcall(require, "dapui")

if not present or vim.g.vscode then
	return
end

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
