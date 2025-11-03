return {
	"greggh/claude-code.nvim",
	enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("claude-code").setup({
			window = {
				split_ratio = 0.3, -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
				position = "float", -- Position of the window: "botright", "topleft", "vertical", "float", etc.
				enter_insert = true, -- Whether to enter insert mode when opening Claude Code
				hide_numbers = true, -- Hide line numbers in the terminal window
				hide_signcolumn = true, -- Hide the sign column in the terminal window
				float = {
					width = "50%", -- Width: number of columns or percentage string
					height = "50%", -- Height: number of rows or percentage string
					row = "center", -- Row position: number, "center", or percentage string
					col = "center", -- Column position: number, "center", or percentage string
					relative = "editor",
					border = "rounded",
				},
			},
			command = "claude",
			command_variants = {
				-- Conversation management
				continue = "--continue", -- Resume the most recent conversation
				resume = "--resume", -- Display an interactive conversation picker

				-- Output options
				verbose = "--verbose", -- Enable verbose logging with full turn-by-turn output
			},
			keymaps = {
				toggle = {
					normal = "<leader>ai",
					terminal = "<leader>ai",
					variants = {
						continue = "<leader>aic",
						verbose = "<leader>aiv",
					},
				},
			},
		})
	end,
}
