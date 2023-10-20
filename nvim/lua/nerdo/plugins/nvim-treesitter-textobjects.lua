-- Adds text objects via treesitter that can be used with motions.
return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	lazy = true,
	config = function()
		require("nvim-treesitter.configs").setup({
			textobjects = {
				select = {
					enable = true,

					-- Automatically jump forward to textobj, similar to targets.vim.
					lookahead = true,

					keymaps = {
						-- You can use capture groups defined in textobjects.scm.
						-- Functions.
						["af"] = "@function.outer",
						["if"] = "@function.inner",

						-- Assignments.
						["a="] = {
							query = "@assignment.outer",
							desc = "Select outer part of an assignment (entire assignment).",
						},
						["i="] = {
							query = "@assignment.inner",
							desc = "Select inner part of an assignment (the part of the assignment you're on).",
						},
						["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment." },
						["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment." },

						-- Function calls.
						["ac"] = { query = "@call.outer", desc = "Select outer part of a call." },
						["ic"] = { query = "@call.inner", desc = "Select inner part of a call." },

						-- Function definitions.
						["af"] = { query = "@function.outer", desc = "Select outer part of a function definition." },
						["if"] = { query = "@function.inner", desc = "Select inner part of a function definition." },

						-- Parameters.
						["ap"] = { query = "@parameter.outer", desc = "Select outer part of a parameter." },
						["ip"] = { query = "@parameter.inner", desc = "Select inner part of a parameter." },

						-- Conditionals.
						["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional." },
						["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional." },

						-- Loops.
						["al"] = { query = "@loop.outer", desc = "Select outer part of a loop." },
						["il"] = { query = "@loop.inner", desc = "Select inner part of a loop." },

						-- Classes.
						["as"] = { query = "@class.outer", desc = "Select outer part of a struct/class." },
						["is"] = { query = "@class.inner", desc = "Select inner part of a struct/class." },
					},
				},
				move = {
					enable = true,
					set_jumps = false, -- Don't update the jump list with these movements.

					goto_next_start = {
						["]c"] = { query = "@call.outer", desc = "Next function call start." },
						["]f"] = { query = "@function.outer", desc = "Next function definition start." },
						["]s"] = { query = "@class.outer", desc = "Next struct/class definition start." },
						["]i"] = { query = "@conditional.outer", desc = "Next conditional start." },
						["]l"] = { query = "@loop.outer", desc = "Next loop start." },
						["]p"] = { query = "@parameter.outer", desc = "Next parameter start." },
						["]="] = { query = "@assignment.outer", desc = "Next assignment start." },
					},

					goto_next_end = {
						["]C"] = { query = "@call.inner", desc = "Next function call end." },
						["]F"] = { query = "@function.inner", desc = "Next function definition end." },
						["]S"] = { query = "@class.inner", desc = "Next struct/class definition end." },
						["]I"] = { query = "@conditional.inner", desc = "Next conditional end." },
						["]L"] = { query = "@loop.inner", desc = "Next loop end." },
						["]P"] = { query = "@parameter.inner", desc = "Next parameter start." },
						["]="] = { query = "@assignment.inner", desc = "Next assignment start." },
					},

					goto_previous_start = {
						["[c"] = { query = "@call.outer", desc = "Prev function call start." },
						["[f"] = { query = "@function.outer", desc = "Prev function definition start." },
						["[s"] = { query = "@class.outer", desc = "Prev struct/class definition start." },
						["[i"] = { query = "@conditional.outer", desc = "Prev conditional start." },
						["[l"] = { query = "@loop.outer", desc = "Prev loop start." },
						["[p"] = { query = "@parameter.outer", desc = "Prev parameter start." },
						["[="] = { query = "@assignment.outer", desc = "Prev assignment start." },
					},

					goto_previous_end = {
						["[C"] = { query = "@call.inner", desc = "Prev function call end." },
						["[F"] = { query = "@function.inner", desc = "Prev function definition end." },
						["[S"] = { query = "@class.inner", desc = "Prev struct/class definition end." },
						["[I"] = { query = "@conditional.inner", desc = "Prev conditional end." },
						["[L"] = { query = "@loop.inner", desc = "Prev loop end." },
						["[P"] = { query = "@parameter.inner", desc = "Prev parameter end." },
						["[="] = { query = "@assignment.inner", desc = "Prev assignment end." },
					},
				},
			},
		})

		local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

		-- vim way: ; goes in the direction you were moving.
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

		-- preserve builtin f, F, t, T repeatability behavior.
		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
	end,
}
