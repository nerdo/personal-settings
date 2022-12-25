local present, lsp_zero = pcall(require, "lsp-zero")

if not present then
	return
end

lsp_zero.set_preferences({
	suggest_lsp_servers = true,
	setup_servers_on_start = true,
	set_lsp_keymaps = false,
	configure_diagnostics = true,
	cmp_capabilities = true,
	manage_nvim_cmp = true,
	call_servers = "local",
	sign_icons = {
		error = "✘",
		warn = "▲",
		hint = "⚑",
		info = "",
	},
})

lsp_zero.ensure_installed({
	"gopls",
	"rust_analyzer",
	"taplo", -- For .toml
	"intelephense",
	"svelte",
	"tsserver",
	"html",
	"cssls",
	"cssmodules_ls",
	"tailwindcss",
	"emmet_ls",
	"jsonls",
	"yamlls",
	"sumneko_lua",
})

local schemastore_is_present, schemastore = pcall(require, "schemastore")
local json_settings = nil

if schemastore_is_present then
	json_settings = {
		schemas = schemastore.json.schemas(),
		validate = { enable = true },
	}
end

local server_options = {
	gopls = {
		settings = {
			gopls = {
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			},
		},
	},

	tsserver = {
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
	},

	sumneko_lua = {
		settings = {
			Lua = {
				hint = {
					enable = true,
				},

				-- from nvchad's .config/nvim/lua/plugins/configs/lspconfig.lua
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					},
					maxPreload = 100000,
					preloadFileSize = 10000,
				},
			},
		},
	},

	jsonls = {
		settings = {
			json = json_settings,
		},
	},
}

for name, options in pairs(server_options) do
	lsp_zero.configure(name, options)
end

-- Keymaps
local on_attach_behaviors = function(bufnr)
	-- LSP keymaps.
	local fmt = function(cmd)
		return function(str)
			return cmd:format(str)
		end
	end

	local opts = { noremap = true, silent = true }
	local map = function(m, lhs, rhs)
		vim.api.nvim_buf_set_keymap(bufnr, m, lhs, rhs, opts)
	end

	local lsp = fmt("<cmd>lua vim.lsp.%s<cr>")
	local diagnostic = fmt("<cmd>lua vim.diagnostic.%s<cr>")

	map("n", "K", lsp("buf.hover()"))
	map("n", "gd", lsp("buf.definition()"))
	map("n", "gD", lsp("buf.declaration()"))
	map("n", "gi", lsp("buf.implementation()"))
	map("n", "go", lsp("buf.type_definition()"))
	map("n", "gr", lsp("buf.references()"))
	map("n", "<leader>lr", lsp("buf.rename()"))
	map("n", "<leader>la", lsp("buf.code_action()"))
	map("x", "<leader>la", lsp("buf.range_code_action()"))
	map("n", "<leader>lf", lsp("buf.format({ async = true })"))
	map("n", "<leader>li", diagnostic("open_float()"))
	map("n", "<C-k>", diagnostic("goto_prev()"))
	map("n", "<C-j>", diagnostic("goto_next()"))

	map("n", "<leader>w", vim.cmd.write())
	vim.keymap.set("n", "<leader>;", function()
		-- Formats before saving.
		vim.lsp.buf.format({ async = false })
		vim.cmd.write()
	end, opts)
end

lsp_zero.on_attach(function(_, bufnr)
	on_attach_behaviors(bufnr)
end)

lsp_zero.setup()

-- Configure debug adapter configurations.
local dap_present, dap = pcall(require, "dap")

if dap_present then
	dap.configurations.rust = {
		{
			type = "rust",
			request = "launch",
			name = "Launch",
			-- TODO `program` should be a function that gets a list of the available binaries from the toml...
			program = "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
		},
	}
end
