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
-- Make Claude terminal transparent immediately on first open
local function set_claude_term_transparency(win)
	-- Blend the float (0 = opaque, 100 = invisible)
	pcall(vim.api.nvim_set_option_value, "winblend", 20, { win = win })

	-- Use floating window highlight groups for this window
	-- IMPORTANT: map Normal/NormalNC -> NormalFloat so bg=NONE carries over
	pcall(
		vim.api.nvim_set_option_value,
		"winhighlight",
		"Normal:NormalFloat,NormalNC:NormalFloat,FloatBorder:FloatBorder",
		{ win = win }
	)
end

-- Mark Claude terminals when their buffers are created
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*claude*",
	callback = function(ev)
		vim.b[ev.buf].is_claude_term = true
	end,
})

-- When the window actually shows that buffer, style it *before* first visible frame
vim.api.nvim_create_autocmd({ "WinNew", "WinEnter", "BufWinEnter" }, {
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		if not vim.b[buf].is_claude_term then
			return
		end

		local win = vim.api.nvim_get_current_win()
		-- Tiny defer ensures the window is fully initialized but still before user sees it
		vim.defer_fn(function()
			set_claude_term_transparency(win)
			-- Optional: force a redraw to avoid any single-frame flash
			vim.cmd("redraw")
		end, 10)
	end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
