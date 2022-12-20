local present, lsp = pcall(require, "lsp-zero")

if not present then
	return
end

lsp.set_preferences({
	suggest_lsp_servers = true,
	setup_servers_on_start = true,
	set_lsp_keymaps = false,
	configure_diagnostics = true,
	cmp_capabilities = true,
	manage_nvim_cmp = true,
	call_servers = 'local',
	sign_icons = {
		error = '✘',
		warn = '▲',
		hint = '⚑',
		info = ''
	}
})

lsp.ensure_installed({
	"gopls",
	"rust_analyzer",
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

	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
}

for name, options in pairs(server_options) do
	lsp.configure(name, options)
end

-- Keymaps
local set_keymaps = function(bufnr)
	local fmt = function(cmd) return function(str) return cmd:format(str) end end

	local map = function(m, lhs, rhs)
		local opts = { noremap = true, silent = true }
		vim.api.nvim_buf_set_keymap(bufnr, m, lhs, rhs, opts)
	end

	local lsp = fmt('<cmd>lua vim.lsp.%s<cr>')
	local diagnostic = fmt('<cmd>lua vim.diagnostic.%s<cr>')

	map('n', 'K', lsp 'buf.hover()')
	map('n', '<leader>gd', lsp 'buf.definition()')
	map('n', '<leader>gD', lsp 'buf.declaration()')
	map('n', '<leader>gi', lsp 'buf.implementation()')
	map('n', '<leader>go', lsp 'buf.type_definition()')
	map('n', '<leader>gr', lsp 'buf.references()')
	map('n', '<leader>lr', lsp 'buf.rename()')
	map('n', '<leader>la', lsp 'buf.code_action()')
	map('x', '<leader>la', lsp 'buf.range_code_action()')
	map("n", "<leader>lf", lsp 'buf.format({ async = true })')
	map('n', '<leader>li', diagnostic 'open_float()')
	map('n', '<C-k>', diagnostic 'goto_prev()')
	map('n', '<C-j>', diagnostic 'goto_next()')
end

lsp.on_attach(function(_, bufnr)
	set_keymaps(bufnr)
end)

lsp.setup()
