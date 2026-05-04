-- SurrealDB treesitter support (replaces incompatible dariuscorvus plugin)
-- Uses native Neovim 0.12 APIs instead of the old nvim-treesitter get_parser_configs()

local query_dir = vim.fn.stdpath("data") .. "/site/queries/surrealdb"
local parser_dir = vim.fn.stdpath("data") .. "/site/parser"

-- Filetype detection
vim.filetype.add({
	extension = {
		surql = "surql",
		surrealql = "surql",
	},
})

-- Write highlight and injection queries
vim.fn.mkdir(query_dir, "p")

local highlights = [[
(keyword) @keyword
(string) @string
(number) @number
(punctuation) @punctuation
(operator) @operator
(variable) @type
(constant) @constant.builtin
(function) @function
(bool) @boolean
(nothing) @type
(comment) @comment
(record) @type
(property) @field
(identifier) @markup.italic
(casting) @conceal
(duration) @number
(type) @type
(delimiter) @punctuation.delimiter
]]

local injections = [[
(scripting_content) @javascript
]]

local hl_file = io.open(query_dir .. "/highlights.scm", "w")
if hl_file then
	hl_file:write(highlights)
	hl_file:close()
end

local inj_file = io.open(query_dir .. "/injections.scm", "w")
if inj_file then
	inj_file:write(injections)
	inj_file:close()
end

-- Auto-compile parser if missing
local parser_path = parser_dir .. "/surrealdb.so"
if vim.fn.filereadable(parser_path) == 0 then
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "surql",
		once = true,
		callback = function()
			local src = vim.fn.stdpath("cache") .. "/tree-sitter-surrealdb"
			if vim.fn.isdirectory(src) == 0 then
				vim.system({ "git", "clone", "--depth", "1", "https://github.com/DariusCorvus/tree-sitter-surrealdb.git", src }):wait()
			end
			vim.fn.mkdir(parser_dir, "p")
			local result = vim.system({ "tree-sitter", "build", "-o", parser_path, src }):wait()
			if result.code == 0 then
				vim.notify("SurrealDB parser compiled successfully. Reopen the file.", vim.log.levels.INFO)
			else
				vim.notify("Failed to compile SurrealDB parser: " .. (result.stderr or ""), vim.log.levels.ERROR)
			end
		end,
	})
end

return {}
