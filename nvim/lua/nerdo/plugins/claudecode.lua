local saved_claude_width = nil

-- Sends current file context to Claude once a WebSocket client connects,
-- so Claude immediately knows which file you're working in.
local pending_context_timer = nil
local function send_file_context_on_connect(context)
	if pending_context_timer then
		pending_context_timer:stop()
		pending_context_timer:close()
		pending_context_timer = nil
	end
	local attempts = 0
	pending_context_timer = vim.loop.new_timer()
	pending_context_timer:start(200, 500, vim.schedule_wrap(function()
		attempts = attempts + 1

		local main_ok, main = pcall(require, "claudecode")
		local srv = main_ok and main.state and main.state.server
		local has_client = srv and srv.state and srv.state.clients and next(srv.state.clients)

		if has_client then
			srv.broadcast("selection_changed", context)
			if pending_context_timer then
				pending_context_timer:stop()
				pending_context_timer:close()
				pending_context_timer = nil
			end
		elseif attempts >= 30 then
			if pending_context_timer then
				pending_context_timer:stop()
				pending_context_timer:close()
				pending_context_timer = nil
			end
		end
	end))
end

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

				-- Capture current file context before focus moves to terminal
				local cursor_context = nil
				if not bufnr then
					local sel = require("claudecode.selection")
					cursor_context = sel.get_cursor_position()
				end

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

				-- Send file context once Claude's WebSocket client connects
				if cursor_context then
					send_file_context_on_connect(cursor_context)
				end
			end,
			desc = "Toggle Claude",
		},
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
	},
}
