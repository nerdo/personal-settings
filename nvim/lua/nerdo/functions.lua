local path = {}

-- My lua skills suck! But thanks StackOverflow: https://stackoverflow.com/a/6023372/2057996

-- Copies the current filename to the system (+) clipboard.
-- Takes a table as an argument with one of the two properties:
-- `relative` = boolean (true by default)
-- `absolute` = boolean
path.copy = function(options)
	local relative = options.relative or not options.absolute
	local expand_arg = "%"

	if not relative then
		expand_arg = "%:p"
	end

	local p = vim.fn.expand(expand_arg)
	vim.fn.setreg("+", p)
	vim.notify('Copied "' .. p .. '" to the clipboard!')
end

-- Displays the current filename.
-- Takes a table as an argument with one of the two properties:
-- `relative` = boolean (true by default)
-- `absolute` = boolean
path.show = function(options)
	local relative = options.relative or not options.absolute
	local expand_arg = "%"
	local label = "Relative"

	if not relative then
		expand_arg = "%:p"
		label = "Absolute"
	end

	local p = vim.fn.expand(expand_arg)
	vim.notify(label .. " path: " .. p)
end

vim.api.nvim_create_user_command("NerdoCpRelPath", function()
	path.copy({ relative = true })
end, {})
vim.api.nvim_create_user_command("NerdoCpAbsPath", function()
	path.copy({ absolute = true })
end, {})
vim.api.nvim_create_user_command("NerdoShowRelPath", function()
	path.show({ relative = true })
end, {})
vim.api.nvim_create_user_command("NerdoShowAbsPath", function()
	path.show({ absolute = true })
end, {})

local line_numbers = {}

-- Toggles line numbers on and off.
line_numbers.toggle = function()
	if vim.api.nvim_win_get_option(0, "number") then
		vim.opt.number = false
		vim.opt.relativenumber = false
	else
		vim.opt.number = true
		vim.opt.relativenumber = true
	end
end

-- Turn on line numbers and set it to relative mode.
line_numbers.set_relative = function()
	vim.opt.number = true
	vim.opt.relativenumber = true
end

-- Turn on line numbers and set it to absolute mode.
line_numbers.set_absolute = function()
	vim.opt.number = true
	vim.opt.relativenumber = false
end

vim.api.nvim_create_user_command("NerdoToggleLineNr", function()
	line_numbers.toggle()
end, {})
vim.api.nvim_create_user_command("NerdoSetLineNrRelative", function()
	line_numbers.set_relative()
end, {})
vim.api.nvim_create_user_command("NerdoSetLineNrAbsolute", function()
	line_numbers.set_absolute()
end, {})

-- Buffer/window functions.
local editor = {}

-- Issues window_cmd if there is more than one visible, editable window open, or buffer_cmd otherwise.
editor.win_or_buf = function(window_cmd, buffer_cmd)
	local win_numbers = vim.api.nvim_tabpage_list_wins(0)
	local num_focusable_windows = 0

	-- Check for focusable windows (treesitter context, for example, creates windows that aren't focusable).
	for i = 1, #win_numbers do
		if vim.api.nvim_win_get_config(win_numbers[i])["focusable"] then
			num_focusable_windows = num_focusable_windows + 1
		end

		if num_focusable_windows > 1 then
			vim.cmd(window_cmd) -- typically "close" to close the window
			return
		end
	end

	-- Issue the buffer_cmd instead, presumably to close/destroy the buffer (typically bd).
	vim.cmd(buffer_cmd)
end

-- Checks to see if a specific buffer filetype is open...
-- Thanks ChatGPT for putting me on the right track...
editor.buffer_filetype_is_open = function(filetype)
	for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_option(buffer, "filetype") == filetype then
			return true
		end
	end
	return false
end

local M = {
	path = path,
	line_numbers = line_numbers,
	editor = editor,
}

return M
