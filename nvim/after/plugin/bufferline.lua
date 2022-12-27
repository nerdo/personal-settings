local present, bufferline = pcall(require, "bufferline")

if not present then
	return
end

bufferline.setup({
	options = {
		indicator = {
			-- It kind of resembles a chat bubble... I like it !
			icon = "◢█",
		},
		separator_style = { " ", " " },
	},

	-- :help bufferline-highlights
	highlights = {
		indicator_selected = {
			fg = "#F2E9EA",
		},
		buffer_selected = {
			bg = "#F2E9EA",
			fg = "#393d47",
			bold = true,
		},
		-- i.e. When there are duplicate file names open in different paths,
		-- this highlight is for the path part...
		duplicate_selected = {
			bg = "#F2E9EA",
			bold = false,
		},
		close_button_selected = {
			bg = "#F2E9EA",
			fg = "#b30018",
			bold = true,
		},
		modified = {
			fg = "#fe5000",
		},
		modified_selected = {
			bg = "#F2E9EA",
			fg = "#fe5000",
		},
	},
})
