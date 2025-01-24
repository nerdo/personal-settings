-- Terminal.
if vim.g.nerdo_is_headless then
	return {}
end

return {
	"chengzeyi/multiterm.vim",
	config = function()
		local nerdo = require("nerdo.functions")

		-- Set up some keybindings just for the terminal buffer.
		vim.api.nvim_create_autocmd("TermOpen", {
			group = nerdo.augroup,
			pattern = "term://*",
			callback = function()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<A-o>", "<Plug>(Multiterm)", opts)

				-- Close the current terminal, and open the requested one.
				local shell = vim.loop.os_getenv("SHELL")
				vim.keymap.set("t", "<F1>", function()
					vim.cmd(":Multiterm")
					vim.cmd(":1Multiterm " .. shell)
				end, { silent = true })
				vim.keymap.set("t", "<F2>", function()
					vim.cmd(":Multiterm")
					vim.cmd(":2Multiterm " .. shell)
				end, { silent = true })
				vim.keymap.set("t", "<F3>", function()
					vim.cmd(":Multiterm")
					vim.cmd(":3Multiterm " .. shell)
				end, { silent = true })
				vim.keymap.set("t", "<F4>", function()
					vim.cmd(":Multiterm")
					vim.cmd(":4Multiterm " .. shell)
				end, { silent = true })

				-- Go into insert mode, cuz it's weird that the terminal opens in any other mode...
				vim.cmd.startinsert()
			end,
		})

		vim.keymap.set({ "n", "i", "v" }, "<A-o>", "<Plug>(Multiterm)")
		vim.keymap.set({ "n", "i", "v" }, "<F1>", ":1Multiterm<CR>", { silent = true })
		vim.keymap.set({ "n", "i", "v" }, "<F2>", ":2Multiterm<CR>", { silent = true })
		vim.keymap.set({ "n", "i", "v" }, "<F3>", ":3Multiterm<CR>", { silent = true })
		vim.keymap.set({ "n", "i", "v" }, "<F4>", ":4Multiterm<CR>", { silent = true })
	end,
}
