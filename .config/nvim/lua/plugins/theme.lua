return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local colors = {
				fg = "#cdd6f4",
				yellow = "#f9e2af",
				cyan = "#89dceb",
				green = "#a6e3a1",
				orange = "#fab387",
				violet = "#cba6f7",
				magenta = "#f38ba8",
				blue = "#74c7ec",
				red = "#f38ba8",
			}

			local transparent_theme = {
				normal = {
					a = { fg = colors.violet, bg = "none", gui = "bold" },
					b = { fg = colors.blue, bg = "none" },
					c = { fg = colors.fg, bg = "none" },
				},
				insert = { a = { fg = colors.green, bg = "none", gui = "bold" } },
				visual = { a = { fg = colors.magenta, bg = "none", gui = "bold" } },
				replace = { a = { fg = colors.red, bg = "none", gui = "bold" } },
				command = { a = { fg = colors.yellow, bg = "none", gui = "bold" } },
				inactive = {
					a = { fg = colors.fg, bg = "none" },
					b = { fg = colors.fg, bg = "none" },
					c = { fg = colors.fg, bg = "none" },
				},
			}

			require("lualine").setup({
				options = {
					theme = transparent_theme,
					icons_enabled = true,
					component_separators = "",
					section_separators = { left = "", right = "" },
					globalstatus = true,
				},
				sections = {
					lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				extensions = { "nvim-tree", "quickfix", "fugitive" },
			})

		-- Force transparency on statusline highlights
			vim.api.nvim_set_hl(0, "StatusLine", { bg = "none", ctermbg = "none" })
			vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none", ctermbg = "none" })
		end,
	},
	{
		"slugbyte/lackluster.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local lackluster = require("lackluster")
			lackluster.setup({
				disable_plugin = {},
				tweak_background = {
					normal = "none",
				},
			})
			-- 	-- vim.cmd.colorscheme("lackluster")
			-- 	-- vim.cmd.colorscheme("lackluster-mint")
		end,
	},
	-- NOTE: Rose pine
	{
		"rose-pine/neovim",
		name = "rose-pine",
		-- priority = 1000,
		config = function()
			require("rose-pine").setup({
				variant = "main", -- auto, main, moon, or dawn
				dark_variant = "main", -- main, moon, or dawn
				dim_inactive_windows = false,
				-- disable_background = true,
				-- 	disable_nc_background = false,
				-- 	disable_float_background = false,
				-- extend_background_behind_borders = false,
				styles = {
					bold = true,
					italic = false,
					transparency = true,
				},
				highlight_groups = {
					ColorColumn = { bg = "#1C1C21" },
					Normal = { bg = "none" }, -- Main background remains transparent
					Pmenu = { bg = "", fg = "#e0def4" }, -- Completion menu background
					PmenuSel = { bg = "#4a465d", fg = "#f8f5f2" }, -- Highlighted completion item
					PmenuSbar = { bg = "#191724" }, -- Scrollbar background
					PmenuThumb = { bg = "#9ccfd8" }, -- Scrollbar thumb
				},
				enable = {
					terminal = false,
					legacy_highlights = false, -- Improve compatibility for previous versions of Neovim
					migrations = true, -- Handle deprecated options automatically
				},
			})

			-- HACK: set this on the color you want to be persistent
			-- when quit and reopening nvim
			-- vim.cmd("colorscheme rose-pine")
			-- vim.cmd.colorscheme("rose-pine-main") -- my favorite
		end,
	},
}
