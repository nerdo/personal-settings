-- Automatic detection of tab size.
return {
	"Darazaki/indent-o-matic",
	config = function()
		require("indent-o-matic").setup {}
	end
}
