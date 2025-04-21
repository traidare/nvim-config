local catUtils = require("nixCatsUtils")

return {
	{
		"nvim-lspconfig",
		for_cat = "general.core",
		on_require = { "lspconfig" },
		dep_of = { "diagflow" },
		lsp = function(plugin)
			require("lspconfig")[plugin.name].setup(vim.tbl_extend("force", {
				--capabilities = require('config.lsps.caps_and_attach').get_capabilities(plugin.name),
				on_attach = function(client, bufnr)
					require("config.lsps.caps_and_attach").on_attach(client, bufnr, plugin.name)
				end,
				flags = {
					debounce_text_changes = 150,
				},
			}, plugin.lsp or {}))
		end,
	},
	{
		"diagflow",
		for_cat = "general.core",
		event = "LspAttach",
		on_require = { "diagflow" },
		after = function()
			require("diagflow").setup({
				enable = true,
				format = function(diagnostic)
					return "[LSP] " .. diagnostic.message
				end,
				placement = "top", -- 'top', 'inline'
				scope = "line", -- 'cursor', 'line'
				show_borders = false,
				show_sign = false,
				padding_right = 1,
				gap = 3,
				--toggle_event = { "InsertEnter" },
				update_event = { "DiagnosticChanged" },
			})
		end,
	},
	{
		"lua_ls",
		enabled = nixCats("lua"),
		lsp = {
			filetypes = { "lua" },
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					formatters = {
						ignoreComments = true,
					},
					signatureHelp = { enabled = true },
					diagnostics = {
						globals = { "nixCats", "vim", "make_test" },
						disable = { "missing-fields" },
					},
					workspace = {
						checkThirdParty = false,
						library = {
							-- '${3rd}/luv/library',
							-- unpack(vim.api.nvim_get_runtime_file('', true)),
						},
					},
					completion = {
						callSnippet = "Replace",
					},
					telemetry = { enabled = false },
				},
			},
		},
	},
	{
		"nil_ls",
		enabled = not catUtils.isNixCats,
		lsp = {
			filetypes = { "nix" },
		},
	},
	{
		"nixd", -- FIXME
		enabled = catUtils.isNixCats,
		lsp = {
			filetypes = { "nix" },
			settings = {
				nixd = {
					nixpkgs = {
						expr = [[import (builtins.getFlake "]] .. nixCats.extra("nixdExtras.nixpkgs") .. [[") { }   ]],
					},
					--options = {
					--    -- (builtins.getFlake "<path_to_system_flake>").legacyPackages.<system>.nixosConfigurations."<user@host>".options
					--    nixos = {
					--        expr = nixCats.extra("nixdExtras.nixos_options")
					--    },
					--},
					diagnostic = {
						suppress = {
							"sema-escaping-with",
						},
					},
				},
			},
		},
	},
	{
		"nushell",
		enabled = nixCats("nu"),
		lsp = {
			filetypes = { "nu" },
		},
	},
	{
		"bashls",
		for_cat = "general.bash",
		lsp = {
			filetypes = { "bash", "sh" },
		},
	},
	{
		"gopls",
		for_cat = "go",
		lsp = {
			filetypes = { "go", "gomod", "gowork", "gotmpl", "templ" },
		},
	},
	-- {"pyright", lsp = {}, },
	{
		"pylsp",
		lsp = {
			filetypes = { "python" },
			cmd = { vim.g.python3_host_prog, "-m", "pylsp" },
			settings = {
				pylsp = {
					plugins = {
						-- formatter options
						black = { enabled = false },
						autopep8 = { enabled = false },
						yapf = { enabled = false },
						-- linter options
						pylint = { enabled = true, executable = "pylint" },
						pyflakes = { enabled = false },
						pycodestyle = { enabled = false },
						-- type checker
						pylsp_mypy = { enabled = true },
						-- auto-completion options
						jedi_completion = { fuzzy = true },
						-- import sorting
						pyls_isort = { enabled = true },
					},
				},
			},
		},
	},
	{
		"ts_ls",
		for_cat = "web.JS",
		lsp = {
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
		},
	},
	{
		"clangd",
		for_cat = "C",
		lsp = {
			filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
			-- unneeded thanks to clangd_extensions-nvim I think
			-- clangd_config = {
			--   init_options = {
			--     compilationDatabasePath="./build",
			--   },
			-- }
		},
	},
	{
		"cmake",
		for_cat = "C",
		lsp = {
			filetypes = { "cmake" },
		},
	},
	{
		"cssls",
		for_cat = "web.HTML",
		lsp = {
			filetypes = { "css", "scss", "less" },
		},
	},
	{
		"eslint",
		for_cat = "web.HTML",
		lsp = {},
	},
	{
		"jsonls",
		for_cat = "data",
		lsp = {
			filetypes = { "json", "jsonc" },
		},
	},
	{
		"yamlls",
		for_cat = "data",
		lsp = {
			filetypes = { "yaml", "yml" },
		},
	},
	{
		"docker_compose_language_service",
		for_cat = "docker",
		lsp = {},
	},
	{
		"dockerls",
		for_cat = "docker",
		lsp = {},
	},
	{
		"texlab",
		for_cat = "tex",
		lsp = {},
	},
	{
		"html",
		for_cat = "web.HTML",
		lsp = {
			filetypes = { "html", "twig", "hbs", "templ" },
			settings = {
				html = {
					format = {
						templating = true,
						wrapLineLength = 120,
						wrapAttributes = "auto",
					},
					hover = {
						documentation = true,
						references = true,
					},
				},
			},
		},
	},
}
