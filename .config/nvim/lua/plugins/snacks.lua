return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	-- NOTE: Options
	opts = {
		input = {
			enabled = true,
		},
		dashboard = {
			enabled = true,
			sections = {
				{
					section = "terminal",
					cmd = "chafa ~/list.webp --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
					height = 17,
					padding = 1,
				},
				{
					pane = 2,
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
			},
		},
		styles = {
			input = {
				keys = {
					n_esc = { "<C-c>", { "cmp_close", "cancel" }, mode = "n", expr = true },
					i_esc = { "<C-c>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
				},
			},
		},
		explorer = {
			enabled = true,
		},
		picker = {
			enabled = true,
			hidden = true,
			ignored = true,
			matchers = {
				frecency = true,
				cwd_bonus = false,
			},
			exclude = {
				".git",
				"node_modules",
				"dist",
				"build",
				".venv",
				"cdk.out",
				".mypy_cache",
				"__pycache__",
				".ruff_cache",
				"Pods/**",
				"ios/Pods/**",
				"ios/build/**",
				"Podfile.lock",
			},
			formatters = {
				file = {
					filename_first = true,
					filename_only = false,
					icon_width = 2,
				},
			},
			layout = {
				preset = "ivy",
				-- When reaching the bottom of the results in the picker, I don't want
				-- it to cycle and go back to the top
				cycle = false,
			},
			layouts = {
				ivy = {
					layout = {
						box = "vertical",
						backdrop = false,
						row = -1,
						width = 0,
						height = 0.3,
						border = "top",
						title = " {title} {live} {flags}",
						title_pos = "left",
						{ win = "input", height = 1, border = "bottom" },
						{
							box = "horizontal",
							{ win = "list", border = "none" },
							{ win = "preview", title = "{preview}", width = 0.5, border = "left" },
						},
					},
					vertical = {
						layout = {
							backdrop = false,
							width = 0.8,
							min_width = 80,
							height = 0.8,
							min_height = 30,
							box = "vertical",
							border = "rounded",
							title = "{title} {live} {flags}",
							title_pos = "center",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
							{ win = "preview", title = "{preview}", height = 0.4, border = "top" },
						},
					},
				},
				matcher = {
					frecency = true,
				},
			},
		},

		image = {
			enabled = function()
				return vim.bo.filetype == "markdown"
			end,
			doc = {
				float = false, -- show image on cursor hover
				inline = false, -- show image inline
				max_width = 50,
				max_height = 30,
				wo = {
					wrap = false,
				},
			},
			convert = {
				notify = true,
				command = "magick",
			},
			img_dirs = {
				"img",
				"images",
				"assets",
				"static",
				"public",
				"media",
				"attachments",
				"Archives/All-Vault-Images/",
				"~/Library",
				"~/Downloads",
			},
		},
		terminal = {
			enabled = true,
			start_insert = true,
		},
	},
	config = function(_, opts)
		require("snacks").setup(opts)
	end,
	-- 	NOTE: Keymaps
	keys = {
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Buffer delete",
			mode = "n",
		},
		{
			"<leader>ba",
			function()
				Snacks.bufdelete.all()
			end,
			desc = "Buffer delete all",
			mode = "n",
		},
		{
			"<leader>bo",
			function()
				Snacks.bufdelete.other()
			end,
			desc = "Buffer delete other",
			mode = "n",
		},
		{
			"<leader>ex",
			function()
				require("snacks").explorer.open({
					layout = "ivy",
				})
			end,
			desc = "Open File Explorer",
		},
		{
			"<leader>rN",
			function()
				require("snacks").rename.rename_file()
			end,
			desc = "Fast Rename Current File",
		},
		{
			"<leader>dB",
			function()
				require("snacks").bufdelete()
			end,
			desc = "Delete or Close Buffer  (Confirm)",
		},
		{
			"<leader>sf",
			function()
				require("snacks").picker.files({
					finder = "files",
					format = "file",
					show_empty = true,
					supports_live = true,
					layout = "ivy",
				})
			end,
			desc = "Find Files (Snacks Picker)",
		},
		{
			"<leader>pc",
			function()
				require("snacks").picker.files({ cwd = "~/dotfiles/nvim/.config/nvim/lua" })
			end,
			desc = "Find Config File",
		},
		{
			"<leader>sw",
			function()
				require("snacks").picker.grep_word({
					on_show = function()
						vim.cmd.stopinsert()
					end,
					layout = "ivy",
				})
			end,
			desc = "[S]earch current [W]ord",
		},
		{
			"<leader>sg",
			function()
				require("snacks").picker.grep({
					layout = "ivy",
				})
			end,
			desc = "[S]earch by [G]rep",
		},
		{
			"<leader><leader>",
			function()
				Snacks.picker.buffers({
					on_show = function()
						vim.cmd.stopinsert()
					end,
					finder = "buffers",
					format = "buffer",
					hidden = false,
					unloaded = true,
					current = true,
					sort_lastused = true,
					layout = "ivy",
					win = {
						input = {
							keys = {
								["d"] = "bufdelete",
							},
						},
						list = { keys = { ["d"] = "bufdelete" } },
					},
				})
			end,
			desc = "[P]Snacks picker buffers",
		},
		{
			"<leader>sk",
			function()
				require("snacks").picker.keymaps({ layout = "ivy" })
			end,
			desc = "Search Keymaps (Snacks Picker)",
		},

		-- Git Stuff
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status({
					finder = "git_log",
					format = "git_log",
					preview = "git_show",
					confirm = "git_checkout",
					layout = "vertical",
				})
			end,
			desc = "Git Status",
		},

		-- Other Utils
		{
			"<leader>thh",
			function()
				require("snacks").picker.colorschemes({ layout = "select" })
			end,
			desc = "Pick Color Themes",
		},
		{
			"<leader>vh",
			function()
				require("snacks").picker.help()
			end,
			desc = "Help Pages",
		},
		{
			"<leader>ai",
			function()
				require("snacks").terminal.toggle("claude --continue")
			end,
			desc = "Toggle Claude Code",
		},
		{
			"<leader>ain",
			function()
				require("snacks").terminal.toggle("claude")
			end,
			desc = "Toggle Claude Code But Continue Most Recent Conversation",
		},

		{
			"<leader>air",
			function()
				require("snacks").terminal.toggle("claude --resume")
			end,
			desc = "Toggle Claude Code But Resume From Selected Conversation",
		},
	},
}

-- NOTE: todo comments w/ snacks
-- {
-- 	"folke/todo-comments.nvim",
-- 	event = { "BufReadPre", "BufNewFile" },
-- 	optional = true,
-- 	keys = {
-- 		{
-- 			"<leader>pt",
-- 			function()
-- 				require("snacks").picker.todo_comments()
-- 			end,
-- 			desc = "All",
-- 		},
-- 		{
-- 			"<leader>pT",
-- 			function()
-- 				require("snacks").picker.todo_comments({ keywords = { "TODO", "FORGETNOT", "FIXME" } })
-- 			end,
-- 			desc = "mains",
-- 		},
-- 	},
-- },
