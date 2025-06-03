return {
	"coder/claudecode.nvim",
	dependencies = {
		"folke/snacks.nvim", -- Optional for enhanced terminal
	},
	config = true,
	keys = {
		{ "<leader>ai", "<cmd>ClaudeCode<cr>",     desc = "Toggle Claude" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v",            desc = "Send to Claude" },
	},
}
