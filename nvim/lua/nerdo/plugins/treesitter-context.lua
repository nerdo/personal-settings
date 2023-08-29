-- Keeps parts of the code on screen for context.
return {
	"nvim-treesitter/nvim-treesitter-context",
	dependencies = { "nvim-treesitter" },
	config = function()
		local nvim_treesitter_context = require("treesitter-context")
		nvim_treesitter_context.setup({
			mode = "topline",
			max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
			trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
			min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
			patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
				-- For all filetypes
				-- Note that setting an entry here replaces all other patterns for this entry.
				-- By setting the 'default' entry below, you can control which nodes you want to
				-- appear in the context window.
				default = {
					"class",
					"function",
					"method",
					"for",
					"while",
					"if",
					"switch",
					"case",
					"interface",
					"struct",
					"enum",

					-- field in an obj
					"field",

					-- php
					"array_creation_expression",

					-- js
					"variable_declarator",
					"assignment_expression",
					"pair",

					-- mostly for json... if it proves to be annoying in other contexts, wrap in json = {}
					"object",
					"array",
				},
				--
				-- Patterns for specific filetypes
				-- If a pattern is missing, *open a PR* so everyone can benefit.
				tex = {
					"chapter",
					"section",
					"subsection",
					"subsubsection",
				},
				haskell = {
					"adt",
				},
				rust = {
					"impl_item",
				},
				terraform = {
					"block",
					"object_elem",
					"attribute",
				},
				scala = {
					"object_definition",
				},
				vhdl = {
					"process_statement",
					"architecture_body",
					"entity_declaration",
				},
				markdown = {
					"section",
				},
				elixir = {
					"anonymous_function",
					"arguments",
					"block",
					"do_block",
					"list",
					"map",
					"tuple",
					"quoted_content",
				},
				json = {
					"pair",
				},
				typescript = {
					"export_statement",
				},
				yaml = {
					"block_mapping_pair",
				},
			},
		})
	end,
}
