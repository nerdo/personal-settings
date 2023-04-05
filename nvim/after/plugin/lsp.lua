local present, lsp_zero = pcall(require, "lsp-zero")

if not present or vim.g.vscode then
	return
end

local neodev_is_present, neodev = pcall(require, "neodev")

if neodev_is_present then
	neodev.setup({})
end

-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/main/advance-usage.md#the-current-api-is-not-enough
lsp_zero.preset("lsp-compe")

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
	"lua_ls",
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
	lua_ls = {
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
	lsp_zero.configure(name, options)
end

-- For some dynamic behavior based on whether trobuble is present and open.
local trouble_is_present, trouble = pcall(require, "trouble")
local nerdo = require("nerdo.functions")

local saga_is_present, _ = pcall(require, "lspsaga")

local open_floating_diagnostic = function()
	if saga_is_present then
		vim.cmd("Lspsaga show_cursor_diagnostics")
	else
		vim.diagnostic.open_float()
	end
end

-- Keymaps
local on_attach_behaviors = function(bufnr)
	-- LSP keymaps.
	local fmt = function(cmd)
		return function(str)
			return cmd:format(str)
		end
	end

	local opts = { noremap = true, silent = true, buffer = bufnr }
	local map = function(m, lhs, rhs)
		vim.keymap.set(m, lhs, rhs, opts)
	end

	local lsp = fmt("<cmd>lua vim.lsp.%s<cr>")
	local diagnostic = fmt("<cmd>lua vim.diagnostic.%s<cr>")

	local goto_next_diagnostic = function()
		if saga_is_present then
			vim.cmd("Lspsaga diagnostic_jump_next")
		else
			vim.diagnostic.goto_next()
		end
	end

	local goto_prev_diagnostic = function()
		if saga_is_present then
			vim.cmd("Lspsaga diagnostic_jump_prev")
		else
			vim.diagnostic.goto_prev({})
		end
	end

	if saga_is_present then
		map("n", "K", "<cmd>Lspsaga hover_doc<CR>")
		map("n", "<leader>li", open_floating_diagnostic)
		map("n", "<leader>lr", "<cmd>Lspsaga rename<CR>")

		-- Things only lspsaga provides...
		map("n", "<leader>o", "<cmd>Lspsaga outline<CR>")
		map("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
	else
		map("n", "K", lsp("buf.hover()"))
		map("n", "<leader>li", diagnostic("open_float()"))
		map("n", "<leader>lr", lsp("buf.rename()"))
	end

	map("n", "gd", lsp("buf.definition()"))
	map("n", "gD", lsp("buf.declaration()"))
	map("n", "gi", lsp("buf.implementation()"))
	map("n", "go", lsp("buf.type_definition()"))
	map("n", "gr", lsp("buf.references()"))
	map({ "n", "v" }, "<leader>la", lsp("buf.code_action()"))
	map("x", "<leader>la", lsp("buf.range_code_action()"))
	map("n", "<leader>lf", lsp("buf.format({ async = true })"))

	-- When Trouble is installed and the panel is open, use its next/prev diagnostics instead.
	-- This has the effect of traveling the entire codebase's diagnostics
	-- (with Trouble's default behavior of showing you everything in the codebase).
	map("n", "<C-k>", function()
		if trouble_is_present and nerdo.editor.buffer_filetype_is_open("Trouble") then
			trouble.previous({ skip_groups = true, jump = true })
		else
			goto_prev_diagnostic()
		end
	end)
	map("n", "<C-j>", function()
		if trouble_is_present and nerdo.editor.buffer_filetype_is_open("Trouble") then
			trouble.next({ skip_groups = true, jump = true })
		else
			goto_next_diagnostic()
		end
	end)

	map("n", "<leader>w", "<Cmd>w<CR>")
	map("n", "<leader>;", function()
		-- Formats before saving.
		vim.lsp.buf.format({ async = false })
		vim.cmd.write()
	end)
end

vim.api.nvim_create_autocmd("User", {
	group = nerdo.augroup,
	pattern = "TroubleJump",
	callback = function()
		vim.schedule(open_floating_diagnostic)
	end,
})

lsp_zero.on_attach(function(_, bufnr)
	on_attach_behaviors(bufnr)
end)

-- Change nvim-cmp settings.
local cmp = require("cmp")

-- Set the priorites of the cmp sources.
local cmp_sources = {}
for k, v in pairs(lsp_zero.defaults.cmp_sources()) do
	if v.name == "nvim_lsp" then
		v.priority = 4
	elseif v.name == "luasnip" then
		v.priority = 3
	elseif v.name == "path" then
		v.priority = 1
	end

	-- Omit buffer from the autocomplete, it's too noisy...
	if v.name ~= "buffer" then
		cmp_sources[k] = v
	end
end

cmp.setup(lsp_zero.defaults.cmp_config({
	sources = cmp_sources,
	completion = {
		-- Turn autocomplete on.
		-- autocomplete = true,
	},
	mapping = lsp_zero.defaults.cmp_mappings({
		["<C-Space>"] = cmp.mapping.complete({}),
		["<C-j>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end,
		["<C-k>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end,
	}),
}))

vim.api.nvim_create_autocmd("FileType", {
	group = nerdo.augroup,
	pattern = "sql,mysql,plsql",
	callback = function()
		cmp.setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
	end,
})

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
