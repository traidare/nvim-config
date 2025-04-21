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
	{
		"pylsp",
		lsp = {
			filetypes = { "python" },
			cmd = { vim.g.python3_host_prog, "-m", "pylsp" },
			settings = {
				pylsp = {
					plugins = {
						-- Defaults to disable
						autopep8 = { enabled = false },
						pycodestyle = { enabled = false },
						pyflakes = { enabled = false },
						yapf = { enabled = false },

						jedi_completion = { fuzzy = true },
						ruff = {
							enabled = true,
							select = {
								"F", -- Pyflakes
								"W", -- Pycodestyle (warnings)
								"E", -- Pycodestyle (errors)
								"N", -- pep8-naming
								"ANN", -- flake8-annotations
								"B", -- flake8-bugbear
								"FA", -- flake8-future-annotations
								"TID", -- flake8-tidy-imports
								"UP007", -- flake8-new-union-types equivalent rule
								"RUF", -- ruff's custom rules
							},
							ignore = {
								"ANN002", -- Missing type annotation for *args
								"ANN003", -- Missing type annotation for **kwargs
								"ANN101", -- Missing type annotation for self in method
								"ANN102", -- Missing type annotation for cls in classmethod
								"ANN201", -- Missing type annotation for public function
								"ANN204", -- Missing return type annotation for special method
								"B904", -- Exception raised within try-except should use raise ... from exc
								"E501", -- Line too long
								"RUF012", -- Mutable class attributes should be annotated with `typing.ClassVar`

								-- Redundant rules with ruff-format:
								"COM812", -- Missing trailing comma (in multi-line lists/tuples/...)
								"COM819", -- Prohibited trailing comma (in single-line lists/tuples/...)
								"D206", -- Checks for docstrings indented with tabs
								"D300", -- Checks for docstring that use ''' instead of """
								"E111", -- Indentation of a non-multiple of 4 spaces
								"E114", -- Comment with indentation  of a non-multiple of 4 spaces
								"E117", -- Checks for over-indented code
								"ISC001", -- Single line implicit string concatenation ("hi" "hey" -> "hihey")
								"ISC002", -- Multi line implicit string concatenation
								"Q000", -- Checks of inline strings that use wrong quotes (' instead of ")
								"Q001", -- Multiline string that use wrong quotes (''' instead of """)
								"Q002", -- Checks for docstrings that use wrong quotes (''' instead of """)
								"Q003", -- Checks for avoidable escaped quotes ("\"" -> '"')
							},
						},
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
