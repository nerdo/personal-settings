-- Auto loads the first `.nvim` file in the current working directory as the workspace file
if vim.g.nerdo_workspace_load_attempted == true then
	return
end

local nerdo = require("nerdo.functions")

local session_filename = ""

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
			session_filename = filename
			return
		end

		-- If we're here, no workspace was loaded...
		-- Start some trouble =]
		local trouble_is_present, _ = pcall(require, "trouble")
		if trouble_is_present then
			vim.schedule(function()
				vim.cmd("Trouble")
				vim.cmd("buffer 1")
			end)
		end
	end,
})

-- When a session loads, do stuff...
vim.api.nvim_create_autocmd("SessionLoadPost", {
	group = nerdo.augroup,
	pattern = "*",
	callback = function()
		if vim.g.nerdo_session_load_trouble then
			vim.cmd("TroubleToggle")
			vim.g.nerdo_session_load_trouble = false
		end
	end,
})

local function mksession(session_file)
	local trouble_is_present, _ = pcall(require, "trouble")
	local trouble_is_open = trouble_is_present and nerdo.editor.buffer_filetype_is_open("Trouble")

	if trouble_is_open then
		-- Close it... Re-open it after the session is saved, because it's trouble to persist!
		vim.cmd("TroubleClose")

		-- Execute the original mksession command
		vim.api.nvim_command("mksession! " .. session_file)

		-- Read the current content of the file
		local file = io.open(session_file, "r")
		if not file then
			return
		end
		local content = file:read("*all")
		file:close()

		-- Prepend the text to the beginning of the content
		local new_content = "lua vim.g.nerdo_session_load_trouble = true\n" .. content

		-- Write the new content to the file
		file = io.open(session_file, "w")
		if not file then
			return
		end
		file:write(new_content)
		file:close()

		vim.cmd("TroubleToggle")
		vim.cmd("bp")
	else
		vim.api.nvim_command("mksession! " .. session_file)
	end
end

vim.keymap.set("n", "<leader>S", function()
	local input_filename = vim.api.nvim_call_function("input", { "Session filename: ", session_filename })
	if input_filename == nil or input_filename == "" then
		return
	end
	session_filename = input_filename
	mksession(session_filename)
end)

vim.g.nerdo_workspace_load_attempted = true
