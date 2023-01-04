-- Auto loads the first `.nvim` file in the current working directory as the workspace file
if vim.g.nerdo_workspace_load_attempted == true then
	return
end

local session_files = vim.fn.glob(vim.fn.getcwd() .. "/*.nvim")
for filename in session_files:gmatch("[^\r\n]+") do
	-- Get the first file name, source it, and return.
	vim.api.nvim_command("source " .. filename)
	return
end

vim.g.nerdo_workspace_load_attempted = true
