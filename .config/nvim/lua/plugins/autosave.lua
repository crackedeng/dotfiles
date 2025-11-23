local group = vim.api.nvim_create_augroup("autosave", {})
vim.api.nvim_create_autocmd("User", {
	pattern = "AutoSaveWritePost",
	group = group,
	callback = function(opts)
		if opts.data.saved_buffer ~= nil then
			print("saved @ " .. vim.fn.strftime("%H:%M:%S"))
		end
	end,
})

local visual_event_group = vim.api.nvim_create_augroup("visual_event", { clear = true })

vim.api.nvim_create_autocmd("ModeChanged", {
	group = visual_event_group,
	pattern = { "*:[vV\x16]*" },
	callback = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "VisualEnter" })
		-- print("VisualEnter")
	end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
	group = visual_event_group,
	pattern = { "[vV\x16]*:*" },
	callback = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "VisualLeave" })
		-- print("VisualLeave")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "snacks_input",
	group = group,
	callback = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "SnacksInputEnter" })
		-- print("snacks input enter")
	end,
})

vim.api.nvim_create_autocmd("BufLeave", {
	group = group,
	pattern = "*", -- check all buffers
	callback = function(opts)
		local ft = vim.bo[opts.buf].filetype
		if ft == "snacks_input" then
			vim.api.nvim_exec_autocmds("User", { pattern = "SnacksInputLeave" })
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "snacks_picker_input",
	group = group,
	callback = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "SnacksPickerInputEnter" })
		-- print("snacks picker input enter")
	end,
})

vim.api.nvim_create_autocmd("BufLeave", {
	group = group,
	pattern = "*", -- check all buffers
	callback = function(opts)
		local ft = vim.bo[opts.buf].filetype
		if ft == "snacks_picker_input" then
			vim.api.nvim_exec_autocmds("User", { pattern = "SnacksPickerInputLeave" })
			-- print("snacks picker input leave")
		end
	end,
})

return {
	{
		"okuuva/auto-save.nvim",
		enabled = true,
		cmd = "ASToggle", -- optional for lazy loading on command
		event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
		opts = {
			enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
			trigger_events = { -- See :h events
				immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" }, -- vim events that trigger an immediate save
				-- vim events that trigger a deferred save (saves after `debounce_delay`)
				defer_save = {
					"InsertLeave",
					"TextChanged",
					{ "User", pattern = "VisualLeave" },
					{ "User", pattern = "SnacksInputLeave" },
					{ "User", pattern = "SnacksPickerInputLeave" },
				},
				cancel_deferred_save = {
					"InsertEnter",
					{ "User", pattern = "VisualEnter" },
					{ "User", pattern = "SnacksInputEnter" },
					{ "User", pattern = "SnacksPickerInputEnter" },
				},
			},
			condition = function(buf)
				local mode = vim.fn.mode()
				if mode == "i" then
					return false
				end
				local filetype = vim.bo[buf].filetype
				if filetype == "harpoon" or filetype == "mysql" then
					return false
				end

				if require("luasnip").in_snippet() then
					return false
				end

				return true
			end,
			write_all_buffers = false, -- write all buffers when the current one meets `condition`
			noautocmd = false,
			lockmarks = false, -- lock marks when saving, see `:h lockmarks` for more details
			debounce_delay = 2000,
			debug = false,
		},
	},
}
