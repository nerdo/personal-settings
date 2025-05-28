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
		expand_arg = expand_arg .. ":p"
	else
		expand_arg = expand_arg .. ":."
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
	local label = ""

	if not relative then
		expand_arg = expand_arg .. ":p"
		label = "Absolute"
	else
		expand_arg = expand_arg .. ":."
		label = "Relative"
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

-- Track the last focused file buffer.
local last_normal_focused_bufnr = 0

-- Gets the last "normal" focused buffer number.
-- That is, the buffer that was entered last that has the "buflisted" option set.
-- (Plugins usually set the &nobuflisted option on special windows).
-- This is how bufferline works, according to https://github.com/akinsho/bufferline.nvim/issues/663
editor.last_normal_focused_bufnr = function()
	return last_normal_focused_bufnr
end

local update_last_normal_focused_bufnr = function()
	local current_bufnr = vim.fn.bufnr()
	local is_buflisted = vim.api.nvim_buf_get_option(current_bufnr, "buflisted")
	if is_buflisted then
		last_normal_focused_bufnr = current_bufnr
	end
end

vim.api.nvim_create_autocmd("BufLeave", {
	group = augroup,
	pattern = "*",
	callback = update_last_normal_focused_bufnr,
})

-- Context variable accessors.
local trouble_auto_leave = true
local set_trouble_auto_leave = function(flag)
	trouble_auto_leave = flag
end
local get_trouble_auto_leave = function()
	return trouble_auto_leave
end

local active_lsp_has_inlay_hint_provider = function()
	local active_clients = vim.lsp.get_clients()
	local current_bufnr = vim.fn.bufnr("%")
	for _, client in pairs(active_clients) do
		if client.attached_buffers[current_bufnr] and client.server_capabilities.inlayHintProvider then
			return true
		end
	end

	return false
end

vim.g.nerdo_is_headless = vim.g.vscode

local M = {
	path = path,
	line_numbers = require("nerdo.line-numbers"),
	editor = editor,
	trouble_auto_leave = {
		set = set_trouble_auto_leave,
		get = get_trouble_auto_leave,
	},
	augroup = augroup,
	active_lsp_has_inlay_hint_provider = active_lsp_has_inlay_hint_provider,
}

return M
