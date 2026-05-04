-- Adds text objects via treesitter that can be used with motions.
return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	lazy = true,
	config = function()
		local select = require("nvim-treesitter-textobjects.select")
		local move = require("nvim-treesitter-textobjects.move")
		local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
			},
			move = {
				set_jumps = false,
			},
		})

		-- Select keymaps.
		local select_maps = {
			-- Assignments.
			["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
			["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
			["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
			["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

			-- Function calls.
			["ac"] = { query = "@call.outer", desc = "Select outer part of a call" },
			["ic"] = { query = "@call.inner", desc = "Select inner part of a call" },

			-- Function definitions.
			["af"] = { query = "@function.outer", desc = "Select outer part of a function definition" },
			["if"] = { query = "@function.inner", desc = "Select inner part of a function definition" },

			-- Parameters.
			["ap"] = { query = "@parameter.outer", desc = "Select outer part of a parameter" },
			["ip"] = { query = "@parameter.inner", desc = "Select inner part of a parameter" },

			-- Conditionals.
			["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
			["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

			-- Loops.
			["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
			["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

			-- Classes.
			["as"] = { query = "@class.outer", desc = "Select outer part of a struct/class" },
			["is"] = { query = "@class.inner", desc = "Select inner part of a struct/class" },
		}
		for lhs, mapping in pairs(select_maps) do
			vim.keymap.set({ "x", "o" }, lhs, function()
				select.select_textobject(mapping.query, "textobjects")
			end, { desc = mapping.desc })
		end

		-- Move keymaps.
		local goto_next_start_maps = {
			["]c"] = { query = "@call.outer", desc = "Next function call start" },
			["]f"] = { query = "@function.outer", desc = "Next function definition start" },
			["]s"] = { query = "@class.outer", desc = "Next struct/class definition start" },
			["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
			["]l"] = { query = "@loop.outer", desc = "Next loop start" },
			["]p"] = { query = "@parameter.outer", desc = "Next parameter start" },
			["]="] = { query = "@assignment.outer", desc = "Next assignment start" },
		}
		for lhs, mapping in pairs(goto_next_start_maps) do
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				move.goto_next_start(mapping.query, "textobjects")
			end, { desc = mapping.desc })
		end

		local goto_next_end_maps = {
			["]C"] = { query = "@call.inner", desc = "Next function call end" },
			["]F"] = { query = "@function.inner", desc = "Next function definition end" },
			["]S"] = { query = "@class.inner", desc = "Next struct/class definition end" },
			["]I"] = { query = "@conditional.inner", desc = "Next conditional end" },
			["]L"] = { query = "@loop.inner", desc = "Next loop end" },
			["]P"] = { query = "@parameter.inner", desc = "Next parameter end" },
		}
		for lhs, mapping in pairs(goto_next_end_maps) do
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				move.goto_next_end(mapping.query, "textobjects")
			end, { desc = mapping.desc })
		end

		local goto_prev_start_maps = {
			["[c"] = { query = "@call.outer", desc = "Prev function call start" },
			["[f"] = { query = "@function.outer", desc = "Prev function definition start" },
			["[s"] = { query = "@class.outer", desc = "Prev struct/class definition start" },
			["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
			["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
			["[p"] = { query = "@parameter.outer", desc = "Prev parameter start" },
			["[="] = { query = "@assignment.outer", desc = "Prev assignment start" },
		}
		for lhs, mapping in pairs(goto_prev_start_maps) do
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				move.goto_previous_start(mapping.query, "textobjects")
			end, { desc = mapping.desc })
		end

		local goto_prev_end_maps = {
			["[C"] = { query = "@call.inner", desc = "Prev function call end" },
			["[F"] = { query = "@function.inner", desc = "Prev function definition end" },
			["[S"] = { query = "@class.inner", desc = "Prev struct/class definition end" },
			["[I"] = { query = "@conditional.inner", desc = "Prev conditional end" },
			["[L"] = { query = "@loop.inner", desc = "Prev loop end" },
			["[P"] = { query = "@parameter.inner", desc = "Prev parameter end" },
			["[="] = { query = "@assignment.inner", desc = "Prev assignment end" },
		}
		for lhs, mapping in pairs(goto_prev_end_maps) do
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				move.goto_previous_end(mapping.query, "textobjects")
			end, { desc = mapping.desc })
		end

		-- Repeatable move: ; goes in the direction you were moving.
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

		-- Preserve builtin f, F, t, T repeatability behavior.
		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
	end,
}
