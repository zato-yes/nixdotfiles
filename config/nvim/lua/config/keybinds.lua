vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)


vim.lsp.config('*', {
	root_markers = { '.git' },
})

vim.diagnostic.config({
	virtual_text  = true,
	severity_sort = true,
	float         = {
		style  = 'minimal',
		border = 'rounded',
		source = 'if_many',
		header = '',
		prefix = '',
	},
	signs         = {
		text = {
			[vim.diagnostic.severity.ERROR] = '✘',
			[vim.diagnostic.severity.WARN]  = '▲',
			[vim.diagnostic.severity.HINT]  = '⚑',
			[vim.diagnostic.severity.INFO]  = '»',
		},
	},
})

local orig = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts            = opts or {}
	opts.border     = opts.border or 'rounded'
	opts.max_width  = opts.max_width or 80
	opts.max_height = opts.max_height or 24
	opts.wrap       = opts.wrap ~= false
	return orig(contents, syntax, opts, ...)
end

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local buf    = args.buf
		local map    = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = buf }) end

		map('n', 'K', vim.lsp.buf.hover)
		map('n', 'gd', vim.lsp.buf.definition)
		map('n', 'gD', vim.lsp.buf.declaration)
		map('n', 'gi', vim.lsp.buf.implementation)
		map('n', 'go', vim.lsp.buf.type_definition)
		map('n', 'gr', vim.lsp.buf.references)
		map('n', 'gs', vim.lsp.buf.signature_help)
		map('n', 'gl', vim.diagnostic.open_float)
		map('n', '<F2>', vim.lsp.buf.rename)
		map({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end)
		map('n', '<F4>', vim.lsp.buf.code_action)

		if client:supports_method('textDocument/documentHighlight') then
			local highlight_augroup = vim.api.nvim_create_augroup('my.lsp.highlight', { clear = false })
			vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
				buffer = buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
				buffer = buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})
		end

		local excluded_filetypes = {}
		if not client:supports_method('textDocument/willSaveWaitUntil')
			and client:supports_method('textDocument/formatting')
			and not excluded_filetypes[vim.bo[buf].filetype]
		then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp.format', { clear = false }),
				buffer = buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})

-- Requires nvim-cmp + cmp-nvim-lsp. If you don't have those installed,
-- delete this line and remove every `capabilities = caps,` below.
local caps = require("cmp_nvim_lsp").default_capabilities()

-- Nix
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config['nixd'] = {
	cmd = { 'nixd' },
	capabilities = capabilities,
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import <nixpkgs> { }",
			},
			options = {
				nixos = {
					expr = '(builtins.getFlake "/home/dummy/nixdotfiles").nixosConfigurations.sweetNix.options',
				},
				home_manager = {
					expr =
					'(builtins.getFlake "/home/dummy/nixdotfiles").nixosConfigurations.sweetNix.options.home-manager.users.type.getSubOptions ["home-manager" "users" "dummy"]',
				},
			},
		},
	},
}
-- Lua
vim.lsp.config['luals'] = {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
	capabilities = caps,
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT' },
			diagnostics = { globals = { 'vim' } },
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file('', true),
			},
			telemetry = { enable = false },
			format = {
				enable = true,
				defaultConfig = {
					indent_style = "tab",
					indent_size = "1",
					quote_style = "none",
					max_line_length = "120",
				},
			},
		},
	},
}

-- Luau (Roblox)
vim.lsp.config['luau_lsp'] = {
	cmd = { 'luau-lsp', 'lsp' },
	filetypes = { 'luau' },
	root_markers = { 'default.project.json', 'sourcemap.json', '.git' },
	capabilities = caps,
	settings = {
		-- Point at your Rojo-generated sourcemap so require() resolution
		-- across ModuleScripts works. Generate with:
		--   rojo sourcemap default.project.json -o sourcemap.json
		["luau-lsp"] = {
			sourcemap = { enabled = true, autogenerate = false },
			types = {
				-- roblox = true pulls in the Roblox API type definitions
				roblox = true,
			},
		},
	},
}

vim.filetype.add({
	extension = {
		luau = 'luau',
	},
})

for name, _ in pairs(vim.lsp.config._configs) do
	if name ~= '*' then
		vim.lsp.enable(name)
	end
end
