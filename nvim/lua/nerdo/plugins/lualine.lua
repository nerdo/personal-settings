-- Status line.
-- Note: for some reason this wipes out the NVIM splash screen buffer.
if vim.g.nerdo_is_headless then
	return {}
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local lualine = require("lualine")

		lualine.setup({
			options = {
				theme = "ayu_dark",
			},
		})
	end,
}
