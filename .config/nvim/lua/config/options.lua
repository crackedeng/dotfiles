vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.o.mouse = "a"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.list = false
vim.o.inccommand = "split"
vim.opt.sidescrolloff = 8
vim.o.scrolloff = 8
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.o.confirm = true

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

-- 1) keep splits balanced when you create/close one
vim.opt.equalalways = true -- rebalance on split/close
vim.opt.eadirection = "both" -- how equalize happens (horiz + vert)

-- 2) when the terminal / GUI is resized, re-equalize all tabs
vim.api.nvim_create_autocmd("VimResized", {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})
