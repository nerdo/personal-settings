-- Display tabs for buffers.
if vim.g.nerdo_is_headless then
	return {}
end

return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local bufferline = require("bufferline")

		local selected_bg = "#fefbea"

		bufferline.setup({
			options = {
				indicator = {
					icon = "█",
				},
				separator_style = { " ", " " },
			},

			-- :help bufferline-highlights
			highlights = {
				fill = {
					bg = "#0f161a",
				},
				indicator_selected = {
					fg = selected_bg,
				},
				buffer_selected = {
					bg = selected_bg,
					fg = "#393d47",
					bold = true,
				},
				-- i.e. When there are duplicate file names open in different paths,
				-- this highlight is for the path part...
				duplicate_selected = {
					bg = selected_bg,
					bold = false,
				},
				close_button_selected = {
					bg = selected_bg,
					fg = "#b30018",
					bold = true,
				},
				modified = {
					fg = "#fe5000",
				},
				modified_selected = {
					bg = selected_bg,
					fg = "#fe5000",
				},
			},
		})
	end,
}
