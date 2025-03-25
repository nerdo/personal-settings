-- LSPs.
-- Mason LSP/DAP/linter/formatter package manager.
return {
	"williamboman/mason.nvim",
	build = ":MasonUpdate", -- :MasonUpdate updates registry contents
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",

		-- Autocompletion
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",

		-- Completion for neovim lua.
		"folke/neodev.nvim",
	},
	config = function()
		local neodev = require("neodev")
		neodev.setup({})

		local mason = require("mason")
		mason.setup({})

		local mason_lspconfig = require("mason-lspconfig")
		mason_lspconfig.setup({
			ensure_installed = {
				"gopls",
				"taplo", -- For .toml
				"intelephense",
				"svelte",
				"ts_ls",
				"html",
				"cssls",
				"cssmodules_ls",
				"tailwindcss",
				"emmet_ls",
				"jsonls",
				"yamlls",
				"lua_ls",
				"vale_ls"
			},
		})
		mason_lspconfig.setup_handlers({
			-- The first entry (without a key) will be the default handler
			-- and will be called for each installed server that doesn't have
			-- a dedicated handler.
			function(server_name) -- default handler (optional)
				require("lspconfig")[server_name].setup({})
			end,
		})
		-- nvim-cmp settings.
		local cmp_is_present, cmp = pcall(require, "cmp")
		local saga_is_present, _ = pcall(require, "lspsaga")

		if cmp_is_present then
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
		end

		local lspconfig = require("lspconfig")

		lspconfig.intelephense.setup({
			settings = {
				intelephense = {
					stubs = {
						-- Undocumented, except for here https://github.com/bmewburn/vscode-intelephense/issues/2728
						"random",

						-- All the stubs...
						-- Reference: https://github.com/bmewburn/intelephense-docs/blob/master/gettingStarted.md#environment
						"amqp",
						"apache",
						"apcu",
						"bcmath",
						"blackfire",
						"bz2",
						"calendar",
						"cassandra",
						"com_dotnet",
						"Core",
						"couchbase",
						"crypto",
						"ctype",
						"cubrid",
						"curl",
						"date",
						"dba",
						"decimal",
						"dom",
						"ds",
						"enchant",
						"Ev",
						"event",
						"exif",
						"fann",
						"FFI",
						"ffmpeg",
						"fileinfo",
						"filter",
						"fpm",
						"ftp",
						"gd",
						"gearman",
						"geoip",
						"geos",
						"gettext",
						"gmagick",
						"gmp",
						"gnupg",
						"grpc",
						"hash",
						"http",
						"ibm_db2",
						"iconv",
						"igbinary",
						"imagick",
						"imap",
						"inotify",
						"interbase",
						"intl",
						"json",
						"judy",
						"ldap",
						"leveldb",
						"libevent",
						"libsodium",
						"libxml",
						"lua",
						"lzf",
						"mailparse",
						"mapscript",
						"mbstring",
						"mcrypt",
						"memcache",
						"memcached",
						"meminfo",
						"meta",
						"ming",
						"mongo",
						"mongodb",
						"mosquitto-php",
						"mqseries",
						"msgpack",
						"mssql",
						"mysql",
						"mysql_xdevapi",
						"mysqli",
						"ncurses",
						"newrelic",
						"oauth",
						"oci8",
						"odbc",
						"openssl",
						"parallel",
						"Parle",
						"pcntl",
						"pcov",
						"pcre",
						"pdflib",
						"PDO",
						"pdo_ibm",
						"pdo_mysql",
						"pdo_pgsql",
						"pdo_sqlite",
						"pgsql",
						"Phar",
						"phpdbg",
						"posix",
						"pspell",
						"pthreads",
						"radius",
						"rar",
						"rdkafka",
						"readline",
						"recode",
						"redis",
						"Reflection",
						"regex",
						"rpminfo",
						"rrd",
						"SaxonC",
						"session",
						"shmop",
						"SimpleXML",
						"snmp",
						"soap",
						"sockets",
						"sodium",
						"solr",
						"SPL",
						"SplType",
						"SQLite",
						"sqlite3",
						"sqlsrv",
						"ssh2",
						"standard",
						"stats",
						"stomp",
						"suhosin",
						"superglobals",
						"svn",
						"sybase",
						"sync",
						"sysvmsg",
						"sysvsem",
						"sysvshm",
						"tidy",
						"tokenizer",
						"uopz",
						"uv",
						"v8js",
						"wddx",
						"win32service",
						"winbinder",
						"wincache",
						"wordpress",
						"xcache",
						"xdebug",
						"xhprof",
						"xml",
						"xmlreader",
						"xmlrpc",
						"xmlwriter",
						"xsl",
						"xxtea",
						"yaf",
						"yaml",
						"yar",
						"zend",
						"Zend OPcache",
						"ZendCache",
						"ZendDebugger",
						"ZendUtils",
						"zip",
						"zlib",
						"zmq",
						"zookeeper"
					}
				}
			}
		})

		lspconfig.gopls.setup({
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

		lspconfig.ts_ls.setup({
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
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
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
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

		lspconfig.jsonls.setup({})

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
		local inlay_hints_enabled = false
		local on_attach_behaviors = function(event)
			local bufnr = event.buf

			local set_inlay_hint = function(enable)
				if nerdo.active_lsp_has_inlay_hint_provider() then
					inlay_hints_enabled = enable
					vim.lsp.inlay_hint.enable(inlay_hints_enabled)
				else
					vim.notify("Inlay hints are not supported by this LSP.")
				end
			end

			-- Inlay hint setup.
			if vim.lsp.inlay_hint then
				if nerdo.active_lsp_has_inlay_hint_provider() then
					set_inlay_hint(inlay_hints_enabled)
				end
				vim.keymap.set("n", "<leader>ih", function()
					set_inlay_hint(not inlay_hints_enabled)
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
				map("n", "<leader>?", "<cmd>Lspsaga show_line_diagnostics<CR>")

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
	end,
}
