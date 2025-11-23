return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		-- Mason must be loaded before its dependents so we need to set it up here.
		-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
		{ "mason-org/mason.nvim", opts = {} },
		{ "nvim-telescope/telescope.nvim" },
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		{ "j-hui/fidget.nvim", opts = {} },

		-- Allows extra capabilities provided by blink.cmp
		"saghen/blink.cmp",
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				snacks_picker = require("snacks").picker
				-- Rename the variable under your cursor.
				map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

				-- Execute a code action, usually your cursor needs to be on top of an error
				map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

				-- Find references for the word under your cursor.
				map("gr", snacks_picker.lsp_references, "[G]oto [R]eferences")

				-- Jump to the implementation of the word under your cursor.
				--  Useful when your language has ways of declaring types without an actual implementation.
				map("gi", snacks_picker.lsp_implementations, "[G]oto [I]mplementation")

				-- Jump to the definition of the word under your cursor.
				--  This is where a variable was first declared, or where a function is defined, etc.
				--  To jump back, press <C-t>.
				map("gd", snacks_picker.lsp_definitions, "[G]oto [D]efinition")

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				--  For example, in C this would take you to the header.
				map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				-- Fuzzy find all the symbols in your current document.
				--  Symbols are things like variables, functions, types, etc.
				map("go", snacks_picker.lsp_symbols, "Open Document Symbols")

				-- Fuzzy find all the symbols in your current workspace.
				--  Similar to document symbols, except searches over your entire project.
				map("gW", snacks_picker.lsp_workspace_symbols, "Open Workspace Symbols")

				-- Jump to the type of the word under your cursor.
				--  Useful when you're not sure what type a variable is and you want to see
				--  the definition of its *type*, not where it was *defined*.
				map("grt", snacks_picker.lsp_type_definitions, "[G]oto [T]ype Definition")

				-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
				---@param client vim.lsp.Client
				---@param method vim.lsp.protocol.Method
				---@param bufnr? integer some lsp support methods only in specific files
				---@return boolean
				local function client_supports_method(client, method, bufnr)
					if vim.fn.has("nvim-0.11") == 1 then
						return client:supports_method(method, bufnr)
					else
						return client.supports_method(method, { bufnr = bufnr })
					end
				end

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if
					client
					and client_supports_method(
						client,
						vim.lsp.protocol.Methods.textDocument_documentHighlight,
						event.buf
					)
				then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end
			end,
		})

		-- Diagnostic Config
		-- See :help vim.diagnostic.Opts
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			} or {},
			virtual_text = false,
			-- virtual_text = {
			-- 	source = "if_many",
			-- 	spacing = 2,
			-- 	format = function(diagnostic)
			-- 		local diagnostic_message = {
			-- 			[vim.diagnostic.severity.ERROR] = diagnostic.message,
			-- 			[vim.diagnostic.severity.WARN] = diagnostic.message,
			-- 			[vim.diagnostic.severity.INFO] = diagnostic.message,
			-- 			[vim.diagnostic.severity.HINT] = diagnostic.message,
			-- 		}
			-- 		return diagnostic_message[diagnostic.severity]
			-- 	end,
			-- },
		})

		local on_attach_pyright = function(client, _)
			-- Disable all capabilities except hoverProvider
			client.server_capabilities.completionProvider = false
			client.server_capabilities.definitionProvider = false
			client.server_capabilities.typeDefinitionProvider = false
			client.server_capabilities.implementationProvider = false
			client.server_capabilities.referencesProvider = false
			client.server_capabilities.documentSymbolProvider = false
			client.server_capabilities.workspaceSymbolProvider = false
			client.server_capabilities.codeActionProvider = false
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			client.server_capabilities.renameProvider = false
			client.server_capabilities.signatureHelpProvider = false
			client.server_capabilities.documentHighlightProvider = false
			client.server_capabilities.foldingRangeProvider = false
			client.server_capabilities.semanticTokensProvider = false
			client.server_capabilities.declarationProvider = false
			client.server_capabilities.callHierarchyProvider = false
			client.server_capabilities.diagnosticProvider = false

			-- Enable hoverProvider
			client.server_capabilities.hoverProvider = true
		end

		-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		-- 	border = "rounded",
		-- 	width = 70,
		-- 	height = 15,
		-- })
		-- vim.lsp.handlers["textDocument/signatureHelp"] =
		-- 	vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

		-- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
		-- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
		-- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
		-- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP specification.
		--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.

		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. Available keys are:
		--  - cmd (table): Override the default command used to start the server
		--  - filetypes (table): Override the default list of associated filetypes for the server
		--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		--  - settings (table): Override the default settings passed when initializing the server.
		--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local servers = {
			pyright = {
				on_attach = on_attach_pyright,
				settings = {
					pyright = {
						-- Using Ruff's import organizer
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							ignore = { "*" },
						},
					},
				},
			},
			lua_ls = {
				-- cmd = { ... },
				-- filetypes = { ... },
				-- capabilities = {},
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						-- diagnostics = { disable = { 'missing-fields' } },
					},
				},
			},
		}
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua",
			"typescript-language-server",
			"eslint-lsp",
			"tailwindcss-language-server",
			"biome",
			"emmet_ls",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
			automatic_installation = false,
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for ts_ls)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
