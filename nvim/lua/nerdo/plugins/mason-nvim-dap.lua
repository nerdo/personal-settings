-- Debug adapter.
if vim.g.nerdo_is_headless then
	return {}
end

return {
	"jay-babu/mason-nvim-dap.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap",
	},
	enabled = function()
		return not vim.g.vscode
	end,
	config = function()
		require("mason-nvim-dap").setup({
			ensure_installed = {
				"codelldb",
				"php",
				-- I want this, but I'm currently getting an error when installing it.
				-- Try installing it with mason directly and reinstate this line once it's resolved.
				-- "node2",
				"bash"
			},
			-- handlers = {},
			handlers = {
				-- Looks for a local .vscode/launch.json in the current workspace root and merges the configurations
				php = function(config)
					if config.name ~= 'php' then
						return
					end

					-- Adjust this path to wherever your launch.json is located (e.g., ".vscode/launch.json")
					local launch_json_path = vim.fn.getcwd() .. "/.vscode/launch.json"

					-- Ensure the file actually exists
					if vim.fn.filereadable(launch_json_path) == 1 then
						-- Read file and decode JSON
						local lines = vim.fn.readfile(launch_json_path)
						local decoded = vim.fn.json_decode(table.concat(lines, "\n"))

						-- Look for matching config by name
						if decoded and decoded.configurations then
							for _, c in ipairs(decoded.configurations) do
								local project_config = {}
								-- Merge fields from the JSON config into the dap config
								for k, v in pairs(c) do
									-- replace occurrences of the variable workspaceRoot with workspaceFolder.
									project_config[k] = string.gsub(v, "%${workspaceRoot}", "${workspaceFolder}")
								end
								table.insert(config.configurations, project_config)
							end
						end
					end
					require('mason-nvim-dap').default_setup(config)
				end,
			}
		})
	end,
}
