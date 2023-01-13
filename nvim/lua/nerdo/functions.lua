local path = {}

-- Create an augroup to associate with my stuff...
local augroup = vim.api.nvim_create_augroup("Nerdo", {})

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

-- Gets table of paths requested on the commandline.
editor.get_command_line_paths = function()
	local paths = {}
	local everything_else_is_a_path = false

	for i, v in ipairs(vim.v.argv) do
		if i == 1 then
			-- Skip the first entry (the executable that was run).
		elseif everything_else_is_a_path then
			table.insert(paths, v)
		else
			if v == "--" then
				everything_else_is_a_path = true
			elseif string.sub(v, 1, 1) ~= "-" then
				table.insert(paths, v)
			end
		end
	end

	return paths
end

-- Track the last focused file through bufferline.
local last_normal_focused_bufnr = 0

local get_last_normal_focused_bufnr = function()
	return last_normal_focused_bufnr
end

local bufferline_present, bufferline = pcall(require, "bufferline")

if bufferline_present then
	vim.api.nvim_create_autocmd("BufEnter", {
		group = augroup,
		pattern = "*",
		callback = function()
			local current_bufnr = vim.fn.bufnr()
			local elements = bufferline.get_elements()

			for _, value in pairs(elements.elements) do
				if value.id == current_bufnr then
					last_normal_focused_bufnr = current_bufnr
					break
				end
			end
		end,
	})
end

-- Context variable accessors.
local trouble_auto_leave = true
local set_trouble_auto_leave = function(flag)
	trouble_auto_leave = flag
end
local get_trouble_auto_leave = function()
	return trouble_auto_leave
end

local M = {
	path = path,
	line_numbers = line_numbers,
	editor = editor,
	last_normal_focused_bufnr = get_last_normal_focused_bufnr,
	trouble_auto_leave = {
		set = set_trouble_auto_leave,
		get = get_trouble_auto_leave,
	},
	augroup = augroup,
}

return M
