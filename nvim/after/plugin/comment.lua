local present, comment = pcall(require, "Comment")

if not present then
	return
end

comment.setup()

vim.keymap.set({ "n", "v" }, "<leader>/", function()
	comment.toggle()
end)
