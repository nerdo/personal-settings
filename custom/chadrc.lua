local M = {}

require("custom.functions")

local overrides = require("custom.overrides")

M.mappings = require("custom.mappings")

M.ui = {
	theme = "chadracula",
	hl_override = {
		CursorLine = {
			bg = "one_bg",
		},
	},
}

M.plugins = {
	override = {
		["kyazdani42/nvim-tree.lua"] = overrides.nvimtree,
		["williamboman/mason.nvim"] = overrides.mason,
		["nvim-treesitter/nvim-treesitter"] = overrides.treesitter,
	},
	user = require("custom.plugins"),
}

return M
