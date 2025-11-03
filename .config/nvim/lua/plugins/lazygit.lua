return {
	"kdheepak/lazygit.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },

	init = function()
		vim.g.lazygit_floating_window_use_plenary = 1
	end,

	keys = {
		{
			"<leader>lg",
			function()
				-- find any open lazygit windows across all tabs
				local lg_wins = {}
				for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
					for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
						local buf = vim.api.nvim_win_get_buf(win)
						local ft = vim.bo[buf].filetype
						local name = vim.api.nvim_buf_get_name(buf)
						if ft == "lazygit" or name:match("lazygit") or name:match("term://.*lazygit") then
							table.insert(lg_wins, win)
						end
					end
				end

				if #lg_wins > 0 then
					-- close all lazygit windows (toggle OFF)
					for _, win in ipairs(lg_wins) do
						if vim.api.nvim_win_is_valid(win) then
							vim.api.nvim_win_close(win, true)
						end
					end
					return
				end

				-- otherwise open (toggle ON)
				if vim.fn.executable("lazygit") == 1 then
					vim.cmd("LazyGit")
				else
					vim.notify("lazygit not found in $PATH", vim.log.levels.ERROR)
				end
			end,
			desc = "Toggle LazyGit",
			mode = "n",
			silent = true,
		},
	},

	-- optional: also allow :LazyGit command to lazy-load
	cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter" },
}
