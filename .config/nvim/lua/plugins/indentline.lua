return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {
		debounce = 100,
		indent = {
			char = "│",
			highlight = { "PaxiPink" },
		},
	},
	config = function(_, opts)
		local ibl = require("ibl")
		local hooks = require("ibl.hooks")

		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "PaxiPink", { fg = "#de92b8" })
		end)

		ibl.setup(opts)
	end,
}
