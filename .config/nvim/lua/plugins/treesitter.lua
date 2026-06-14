return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup()
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
		local ensure = {
			"bash", "c", "diff", "html", "lua", "luadoc",
			"markdown", "markdown_inline", "query", "vim", "vimdoc", "http",
		}
		for _, lang in ipairs(ensure) do
			pcall(function() vim.treesitter.language.add(lang) end)
		end
	end,
}
