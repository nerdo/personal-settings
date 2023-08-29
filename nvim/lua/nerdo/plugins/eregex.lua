-- Perl compatible regular expressions.
return {
	"othree/eregex.vim",
	init = function()
		vim.g.eregex_default_enable = false
		vim.g.eregex_force_case = true
	end
}
