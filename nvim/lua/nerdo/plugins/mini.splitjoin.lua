-- Split/join functionality
return {
	"echasnovski/mini.splitjoin",
	version = false,
	config = function()
		require('mini.splitjoin').setup({
			mappings = {
				toggle = '',
				split = '<leader>s',
				join = '<leader>j',
			},
		})
	end,
}
