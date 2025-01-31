-- Soft wrapping for text files.
opts = {
    softener = {
        asciidoc = true,
        gitcommit = true,
        latex = true,
        mail = true,
        markdown = true,
        rst = true,
        tex = true,
        text = true,
    }
}

return {
    "andrewferrier/wrapping.nvim",
    config = function()
        require("wrapping").setup(opts)
    end
}
