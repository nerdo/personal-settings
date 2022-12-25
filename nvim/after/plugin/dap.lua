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
vim.keymap.set("n", "<S-F5>", function()
	dap.terminate()
end)
-- S-F5 seems to read as F17 in my terminal...
vim.keymap.set("n", "<F17>", function()
	dap.terminate()
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

-- Set up debug adapters.
local mason_present, mason_registry = pcall(require, "mason-registry")

-- This assumes that codelldb was installed with mason.
if mason_present and mason_registry.is_installed("codelldb") then
	-- For codelldb support.
	-- Probably couldn't have gotten this working without looking at simrat/rust-tools.nvim
	-- Specifically, https://github.com/simrat39/rust-tools.nvim/wiki/Debugging/61fdcef2e4afeac53553542a072d97b26d2f6e5a
	-- The only reason I didn't end up just using rust-tools is because it broke on me unexpectedly,
	-- and, tbh, I have pretty much what I need with lsp-zero...
	local function get_codelldb_adapter_settings(extension_path)
		-- Get the file extension for dynamic libraries based on the operating system.
		local os_name = vim.loop.os_uname().sysname
		local dynamic_lib_extension = "os_name_" .. os_name
		if os_name == "Darwin" then
			-- macOS
			dynamic_lib_extension = "dylib"
		elseif os_name == "Windows_NT" then
			-- Windows
			dynamic_lib_extension = "dll"
		elseif os_name == "Linux" then
			-- Linux
			dynamic_lib_extension = "so"
		end

		local codelldb_path = extension_path .. "adapter/codelldb"
		local liblldb_path = extension_path .. "lldb/lib/liblldb." .. dynamic_lib_extension

		return {
			codelldb_path = codelldb_path,
			liblldb_path = liblldb_path,
		}
	end

	local codelldb_settings =
		get_codelldb_adapter_settings(vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/")

	-- Configure codelldb adapter for rust.
	dap.adapters.rust = {
		type = "server",
		executable = {
			args = {
				"--liblldb",
				codelldb_settings.liblldb_path,
				"--port",
				"${port}",
			},
			command = codelldb_settings.codelldb_path,
		},
		host = "127.0.0.1",
		port = "${port}",
	}
end
