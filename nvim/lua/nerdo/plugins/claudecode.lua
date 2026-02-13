local saved_claude_width = nil

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
			terminal = {
				split_width_percentage = 0.40,
			},
		})
	end,
	keys = {
		{
			"<leader>ai",
			function()
				local terminal = require("claudecode.terminal")
				local bufnr = terminal.get_active_terminal_bufnr()

				-- Save width before toggling (if terminal is visible)
				if bufnr then
					local info = vim.fn.getbufinfo(bufnr)
					if info and #info > 0 and #info[1].windows > 0 then
						saved_claude_width = vim.api.nvim_win_get_width(info[1].windows[1])
					end
				end

				vim.cmd("ClaudeCode")

				-- Restore saved width after showing
				if saved_claude_width then
					vim.schedule(function()
						local new_bufnr = terminal.get_active_terminal_bufnr()
						if new_bufnr then
							local new_info = vim.fn.getbufinfo(new_bufnr)
							if new_info and #new_info > 0 and #new_info[1].windows > 0 then
								vim.api.nvim_win_set_width(new_info[1].windows[1], saved_claude_width)
							end
						end
					end)
				end
			end,
			desc = "Toggle Claude",
		},
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
	},
}
