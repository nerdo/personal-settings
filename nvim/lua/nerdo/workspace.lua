-- Auto loads the first `.nvim` file in the current working directory as the workspace file
if vim.g.nerdo_workspace_load_attempted == true then
	return
end

-- When vim loads, source the workspace.
vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	callback = function()
		-- Don't try to load the session if an argument was given on the command line
		-- This is naive, because it doesn't take into account that some of these may be options
		-- The right way to do this: check if there are any arguments after an option --
		-- OR if there are any options that don't otherwise begin with a -
		if #vim.v.argv > 1 then
			return
		end

		local session_files = vim.fn.glob(vim.fn.getcwd() .. "/*.nvim")
		for filename in session_files:gmatch("[^\r\n]+") do
			-- Get the first file name, source it, and return.
			vim.api.nvim_command("source " .. filename)
			return
		end
	end,
	once = true,
})

vim.g.nerdo_workspace_load_attempted = true
