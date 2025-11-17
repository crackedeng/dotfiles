return {
	{
		"rest-nvim/rest.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				table.insert(opts.ensure_installed, "http")

				vim.keymap.set("n", "<leader>rr", "<cmd>Rest run<cr>", { desc = "Run HTTP request" })
			end,
		},
	},
	{ "typicode/bg.nvim", lazy = false },
	{ "danilamihailov/beacon.nvim" },
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		opts = {
			preset = "minimal",
			transparent_bg = true,
			hi = {
				error = "DiagnosticError", -- Highlight for error diagnostics
				warn = "DiagnosticWarn", -- Highlight for warning diagnostics
				info = "DiagnosticInfo", -- Highlight for info diagnostics
				hint = "DiagnosticHint", -- Highlight for hint diagnostics
				arrow = "NonText", -- Highlight for the arrow pointing to diagnostic
				background = "CursorLine", -- Background highlight for diagnostics
				mixing_color = "Normal", -- Color to blend background with (or "None")
			},
			add_messages = {
				messages = true, -- Show full diagnostic messages
				display_count = false, -- Show diagnostic count instead of messages when cursor not on line
				use_max_severity = false, -- When counting, only show the most severe diagnostic
			},
			multilines = {
				enabled = true,
			},
		},
	},
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
