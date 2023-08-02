local present, mason = pcall(require, "mason")

if not present then
	return
end

mason.setup({})

local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
	ensure_installed = {
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
	},
})
mason_lspconfig.setup_handlers {
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup {}
	end,
	-- Next, you can provide a dedicated handler for specific servers.
	-- For example, a handler override for the `rust_analyzer`:
	["rust_analyzer"] = function()
		require("rust-tools").setup {}
	end
}
-- nvim-cmp settings.
local cmp = require("cmp")

local saga_is_present, _ = pcall(require, "lspsaga")

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
	}, {
		{ name = "buffer" },
	}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require("lspconfig")

lspconfig.gopls.setup({
	capabilities = capabilities,
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
})

lspconfig.tsserver.setup({
	capabilities = capabilities,
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
})

lspconfig.lua_ls.setup({
	capabilities = capabilities,
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
				checkThirdParty = false,
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
				maxPreload = 100000,
				preloadFileSize = 10000,
			},
		},
	},
})

lspconfig.jsonls.setup({
	capabilities = capabilities,
})

lspconfig.rust_analyzer.setup({
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			checkOnSave = {
				command = "clippy",
			},
		},
	},
})

-- For some dynamic behavior based on whether trobuble is present and open.
local trouble_is_present, trouble = pcall(require, "trouble")
local nerdo = require("nerdo.functions")

if saga_is_present then
	-- Turn off diagnostic floating text.
	-- LSP saga keymaps are more useful and less invasive.
	vim.diagnostic.config({
		virtual_text = false,
	})
end

local open_floating_diagnostic = function()
	if saga_is_present then
		vim.cmd("Lspsaga show_cursor_diagnostics")
	else
		vim.diagnostic.open_float()
	end
end

-- Keymaps
local on_attach_behaviors = function(event)
	local bufnr = event.buf

	-- Inlay hint setup.
	if nerdo.active_lsp_has_inlay_hint_provider() and vim.lsp.inlay_hint then
		local inlay_hints_enabled = true
		vim.lsp.inlay_hint(bufnr, true)
		vim.keymap.set("n", "<leader>ih", function()
			inlay_hints_enabled = not inlay_hints_enabled
			vim.lsp.inlay_hint(bufnr, inlay_hints_enabled)
		end, { buffer = bufnr })
	else
		vim.keymap.set("n", "<leader>ih", function()
			vim.notify("Inlay hints are not supported by this LSP.")
		end, { buffer = bufnr })
	end

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
		-- Replace some default LSP functionality with lsp saga.
		map("n", "K", "<cmd>Lspsaga hover_doc<CR>")
		map("n", "<leader>li", open_floating_diagnostic)
		map("n", "<leader>lr", "<cmd>Lspsaga rename<CR>")

		-- Things only lspsaga provides...

		-- Show diagnostics
		map("n", "<leader>!", "<cmd>Lspsaga show_workspace_diagnostics<CR>")
		map("n", "<leader>%!", "<cmd>Lspsaga show_buffer_diagnostics<CR>")
		map("n", "<leader><leader>", "<cmd>Lspsaga show_line_diagnostics<CR>")

		-- Find references.
		map("n", "gh", "<cmd>Lspsaga finder<CR>")

		-- Peek definition.
		map("n", "gp", "<cmd>Lspsaga peek_definition<CR>")

		-- Call hierarchy.
		map("n", "<leader>ki", "<cmd>Lspsaga incoming_calls<CR>")
		map("n", "<leader>ko", "<cmd>Lspsaga outgoing_calls<CR>")

		-- Code ation.
		map({ "n", "v" }, "<leader>la", "<cmd>Lspsaga code_action<CR>")
	else
		map("n", "K", lsp("buf.hover()"))
		map("n", "<leader>li", diagnostic("open_float()"))
		map("n", "<leader>lr", lsp("buf.rename()"))
		map({ "n", "v" }, "<leader>la", lsp("buf.code_action()"))
	end

	map("n", "gd", lsp("buf.definition()"))
	map("n", "gD", lsp("buf.declaration()"))
	map("n", "gi", lsp("buf.implementation()"))
	map("n", "go", lsp("buf.type_definition()"))
	map("n", "gr", lsp("buf.references()"))
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

if trouble_is_present then
	vim.api.nvim_create_autocmd("User", {
		group = nerdo.augroup,
		pattern = "TroubleJump",
		callback = function()
			vim.schedule(open_floating_diagnostic)
		end,
	})
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("NerdoLspConfig", {}),
	callback = function(event)
		on_attach_behaviors(event)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = nerdo.augroup,
	pattern = "sql,mysql,plsql",
	callback = function()
		cmp.setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
	end,
})

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
