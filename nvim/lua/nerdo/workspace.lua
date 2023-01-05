-- Auto loads the first `.nvim` file in the current working directory as the workspace file
if vim.g.nerdo_workspace_load_attempted == true then
	return
end

local nerdo = require("nerdo.functions")

-- When vim loads, source the workspace.
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	pattern = "*",
	callback = function()
		-- Don't try to load the session if an argument was given on the command line
		if #nerdo.editor.get_command_line_paths() > 0 then
			return
		end

		local session_files = vim.fn.glob(vim.fn.getcwd() .. "/*.nvim")
		for filename in session_files:gmatch("[^\r\n]+") do
			-- Get the first file name, source it, and return.
			vim.api.nvim_command("source " .. filename)
			return
		end
	end,
})

vim.g.nerdo_workspace_load_attempted = true
