vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

vim.keymap.set("n", "<leader>sv", "<C-w>v<C-w>l", { desc = "Split vertically and move right" })
vim.keymap.set("n", "<leader>sh", "<C-w>s<C-w>j", { desc = "Split horizontally and move down" })

local term_bufnr = nil

vim.keymap.set("n", "<leader>th", function()
	-- Check if a terminal window is visible
	local term_win = nil
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].buftype == "terminal" then
			term_win = win
			term_bufnr = buf
			break
		end
	end

	if term_win then
		-- Hide the visible terminal (keep process alive)
		vim.api.nvim_set_current_win(term_win)
		vim.cmd("hide")
	else
		local total_height = vim.o.lines
		local height = math.floor(total_height * 0.25)
		vim.cmd(height .. "split")
		if term_bufnr and vim.api.nvim_buf_is_valid(term_bufnr) then
			-- Reuse the previous terminal buffer
			vim.api.nvim_set_current_buf(term_bufnr)
		else
			-- Create a new terminal
			vim.cmd("terminal")
			term_bufnr = vim.api.nvim_get_current_buf()
		end
		-- Automatically enter terminal (insert) mode
		vim.cmd("startinsert")
	end
end, { desc = "[T]oggle [H]orizontal terminal (25%)" })

vim.keymap.set("n", "<leader>tv", function()
	-- open terminal vertically and start insert mode
	vim.cmd("vsplit | terminal")
	vim.cmd("startinsert")
end, { desc = "Open terminal (vertical split and start in insert mode)" })

vim.keymap.set("n", "<leader>tf", function()
	local win = vim.api.nvim_get_current_win()
	local height = vim.api.nvim_win_get_height(win)
	local full = vim.o.lines - 3 -- minus command bar and borders
	if height < full then
		vim.api.nvim_win_set_height(win, full)
	else
		vim.api.nvim_win_set_height(win, math.floor(vim.o.lines * 0.25))
	end
end, { desc = "[T]oggle terminal [F]ullscreen" })

-- Escape terminal mode quickly
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
