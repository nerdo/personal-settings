local M = {}

M.custom_statuscolumn = function(lnum, rnum)
	if rnum ~= 0 then
		return "%s %#LineNrAbsolute#" .. lnum .. "%* %=" .. rnum .. " "
	end
	return "%s " .. lnum .. " "
end

-- Toggles line numbers on and off.
M.cycle = function()
	M.current_setting = math.max(1, (M.current_setting + 1) % (#M.options + 1))
	M.refresh()
end

-- Custom line numbers - grayed out absolute line numbers alongside relative line numbers
M.set_custom = function()
	vim.o.statuscolumn = "%{%v:lua.require'nerdo.line-numbers'.custom_statuscolumn(v:lnum, v:relnum)%}"
	vim.opt.number = true
	vim.opt.relativenumber = true
	M.current_setting = 1
end

-- Turn on line numbers and set it to relative mode.
M.set_relative = function()
	vim.o.statuscolumn = ""
	vim.opt.number = true
	vim.opt.relativenumber = true
	M.current_setting = 2
end

-- Turn on line numbers and set it to absolute mode.
M.set_absolute = function()
	vim.o.statuscolumn = ""
	vim.opt.number = true
	vim.opt.relativenumber = false
	M.current_setting = 3
end

M.options = { M.set_custom, M.set_relative, M.set_absolute }
M.current_setting = 1

M.refresh = function()
	M.options[M.current_setting]()
end

vim.api.nvim_create_user_command("NerdoCycleLineNr", function()
	M.cycle()
end, {})
vim.api.nvim_create_user_command("NerdoSetLineNrCustom", function()
	M.set_custom()
end, {})
vim.api.nvim_create_user_command("NerdoSetLineNrRelative", function()
	M.set_relative()
end, {})
vim.api.nvim_create_user_command("NerdoSetLineNrAbsolute", function()
	M.set_absolute()
end, {})

return M
