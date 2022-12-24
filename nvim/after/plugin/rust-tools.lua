local present, rt = pcall(require, "rust-tools")

if not present then
	return
end

-- For codelldb support.
function get_codelldb_adapter_settings(extension_path)
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

-- This assumes that codelldb was installed with mason.
local codelldb_settings = get_codelldb_adapter_settings(vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/")

local rt_dap_exists, rt_dap = pcall(require, "rust-tools.dap")

local dap_adapter = nil
if rt_dap_exists then
	dap_adapter = rt_dap.get_codelldb_adapter(codelldb_settings.codelldb_path, codelldb_settings.liblldb_path)
	dap_adapter.name = "rust"
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

	dap = {
		adapter = dap_adapter,
	},
})
