-- Navigate git worktrees. Thanks ThePrimeagen :D.
if vim.g.nerdo_is_headless then
	return {}
end

return {
	"ThePrimeagen/git-worktree.nvim",
	config = function()
		local gitworktree = require("git-worktree")
		gitworktree.setup({})

		local telescope_is_present, telescope = pcall(require, "telescope")
		if telescope_is_present then
			telescope.load_extension("git_worktree")
			vim.keymap.set({ "n" }, "<leader>wc", function()
				telescope.extensions.git_worktree.create_git_worktree()
			end)
			vim.keymap.set({ "n" }, "<leader>wo", function()
				telescope.extensions.git_worktree.git_worktrees()
			end)
		end
	end,
}
