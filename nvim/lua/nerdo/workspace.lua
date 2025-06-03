-- Auto loads the first `.nvim` file in the current working directory as the workspace file
if vim.g.nerdo_workspace_load_attempted == true then
	return
end

local nerdo = require("nerdo.functions")

local trouble_is_present, trouble = pcall(require, "trouble")

local session_filename = ""

-- When vim loads, source the workspace.
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	pattern = "*",
	callback = function()
		vim.schedule(function()
			-- Don't try to load the session if an argument was given on the command line
			if #nerdo.editor.get_command_line_paths() > 0 then
				return
			end

			local session_files = vim.fn.glob(vim.fn.getcwd() .. "/*.nvim")
			for filename in session_files:gmatch("[^\r\n]+") do
				-- If we're here, no workspace was loaded...
				-- Start some trouble =]
				if trouble_is_present then
					vim.api.nvim_create_autocmd("SourcePost", {
						once = true,
						pattern = "*",
						callback = function()
							vim.schedule(function()
								if vim.g.nerdo_session_load_trouble then
									trouble.open({ mode = 'project' })
								end
							end)
						end,
					})
				end

				-- Get the first file name, source it, and return.
				vim.api.nvim_command("source " .. filename)
				session_filename = filename
				return
			end

			if trouble_is_present then
				-- Not loading a session. I like to start trouble :>
				-- trouble.open({ mode = 'project' })
			end
		end)
	end,
})

local function mksession(session_file)
	local trouble_is_open = trouble_is_present and nerdo.editor.buffer_filetype_is_open("Trouble")

	if trouble_is_open then
		-- Close it... Re-open it after the session is saved, because it's trouble to persist!
		trouble.close()

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

		trouble.open({ mode = 'project' })
		vim.api.nvim_set_current_buf(nerdo.editor.last_normal_focused_bufnr())
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
