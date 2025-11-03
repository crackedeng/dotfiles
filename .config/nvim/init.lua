require("config.options")
require("config.keybinds")
require("config.lazy")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Make float backgrounds transparent (and its border)
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- When the Claude terminal opens, set winblend & winhighlight on that window
vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter" }, {
	pattern = "term://*claude*",
	callback = function(ev)
		-- use the current window that showed the terminal
		local win = vim.api.nvim_get_current_win()

		-- Blend the floating window (0 = opaque, 100 = invisible)
		pcall(vim.api.nvim_set_option_value, "winblend", 20, { win = win })

		-- Make sure the window actually uses the float highlight groups
		pcall(
			vim.api.nvim_set_option_value,
			"winhighlight",
			"NormalFloat:NormalFloat,FloatBorder:FloatBorder",
			{ win = win }
		)
	end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
