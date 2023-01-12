local present, indent_blankline = pcall(require, "indent_blankline")

if not present or vim.g.vscode then
	return
end

local context_char
if vim.g.vscode then
	-- VSCode has space between lines, so this looks ugly.
	-- Use Indenticator in VSCode for this instead...
	context_char = ""
else
	context_char = "▎"
end

local settings = {
	char = "",
	context_char = context_char,
	space_char_blankline = " ",
	use_treesitter = true,
	show_current_context = true,
	show_current_context_start = true,
	show_trailing_blankline_on_indent = false,
	buftype_exclude = { "terminal" },
	filetype_exclude = {
		"netrw",
		"packer",
	},
}

if vim.g.vscode then
	settings.context_highlight_list = {
		"IndentBlanklineSpaceCharBlankline",
	}
end

indent_blankline.setup(settings)

-- Set some colors for indent blankline to make it stand out without being obtrusive.
vim.api.nvim_set_hl(0, "IndentBlanklineContextStart", { bg = "#0841A1" })
vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = "#0841A1" })
vim.api.nvim_set_hl(0, "IndentBlanklineSpaceCharBlankline", {})
