local present, sig = pcall(require, "lsp_signature")

if not present then
	return
end

sig.setup({
	hint_inline = function() return true end
})
