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

vim.api.nvim_create_user_command("CpRelPath", function()
	path.copy({ relative = true })
end, {})
vim.api.nvim_create_user_command("CpAbsPath", function()
	path.copy({ absolute = true })
end, {})
vim.api.nvim_create_user_command("ShowRelPath", function()
	path.show({ relative = true })
end, {})
vim.api.nvim_create_user_command("ShowAbsPath", function()
	path.show({ absolute = true })
end, {})

local M = {
	path = path,
}

return M
