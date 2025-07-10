return {
	"coder/claudecode.nvim",
	dependencies = {
		"folke/snacks.nvim", -- Optional for enhanced terminal
	},
	config = function()
		-- Dynamic approach to find claude binary
		local function find_claude_command()
			-- Option 1: Check for local claude binary first
			local local_claude = vim.fn.expand("~/.claude/local/claude")
			if vim.fn.executable(local_claude) == 1 then
				return local_claude
			end

			-- Option 2: Check if claude is in PATH
			if vim.fn.executable("claude") == 1 then
				return "claude"
			end

			-- Option 3: Try to get from shell alias (requires shell evaluation)
			-- This is more complex but possible
			local handle = io.popen("zsh -i -c 'which claude' 2>/dev/null")
			if handle then
				local result = handle:read("*a")
				handle:close()
				local claude_path = result:gsub("%s+", "")
				if claude_path ~= "" and vim.fn.executable(claude_path) == 1 then
					return claude_path
				end
			end

			-- Default fallback
			return "claude"
		end

		require("claudecode").setup({
			terminal_cmd = find_claude_command(),
		})
	end,
	keys = {
		{ "<leader>ai", "<cmd>ClaudeCode<cr>",     desc = "Toggle Claude" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v",            desc = "Send to Claude" },
	},
}
