local present, rt = pcall(require, "rust-tools")

if not present then
	return
end

local mason_registry = require("mason-registry")
local codelldb = mason_registry.get_package("codelldb")
local extension_path = codelldb:get_install_path() .. "/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
local inlay_hints_enabled = true

rt.setup({
	dap = {
		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
	},
	server = {
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })

			-- Code action groups
			vim.keymap.set("n", "<Leader>la", rt.code_action_group.code_action_group, { buffer = bufnr })

			-- Toggles inlay hints globally.
			vim.keymap.set("n", "<leader>ih", function()
				inlay_hints_enabled = not inlay_hints_enabled
				if inlay_hints_enabled then
					rt.inlay_hints.enable()
				else
					rt.inlay_hints.disable()
				end
			end, { buffer = bufnr })
		end,
	},
	tools = {
		hover_actions = {
			auto_focus = true,
		},
		inlay_hints = {
			auto = inlay_hints_enabled,
			parameter_hints_prefix = "<- ",
			other_hints_prefix = "=> ",
			highlight = "LspInlayHint",
		},
	},
})
