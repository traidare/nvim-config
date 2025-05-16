local catUtils = require("nixCatsUtils")

return {
  {
    "nvim-lspconfig",
    for_cat = "general.core",
    on_require = { "lspconfig" },
    lsp = function(plugin)
      vim.lsp.config(plugin.name, plugin.lsp or {})
      vim.lsp.enable(plugin.name)
    end,
    before = function(_)
      vim.lsp.config("*", {
        on_attach = require("config.lsps.on_attach"),
      })
    end,
  },
  {
    "diagflow.nvim",
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
    enabled = nixCats("lua") or nixCats("neonixdev"),
    lsp = {
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
    "lazydev.nvim",
    for_cat = "neonixdev",
    cmd = { "LazyDev" },
    ft = "lua",
    after = function(_)
      require("lazydev").setup({
        library = {
          {
            words = { "uv", "vim%.uv", "vim%.loop" },
            path = (nixCats.pawsible({ "allPlugins", "start", "luvit-meta" }) or "luvit-meta") .. "/library",
          },
          { words = { "nixCats" }, path = (nixCats.nixCatsPath or "") .. "/lua" },
        },
      })
    end,
  },
  {
    "nil_ls",
    enabled = not catUtils.isNixCats,
    lsp = {},
  },
  {
    "nixd", -- FIXME
    enabled = catUtils.isNixCats,
    lsp = {
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
    for_cat = "nu",
    lsp = {},
  },
  {
    "bashls",
    for_cat = "general.bash",
    lsp = {},
  },
  {
    "gopls",
    for_cat = "go",
    lsp = {},
  },
  {
    "pylsp",
    lsp = {
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
    "racket_langserver",
    for_cat = "racket",
    lsp = {
      filetypes = { "racket", "rkt" },
    },
  },
  {
    "ts_ls",
    for_cat = "web.JS",
    lsp = {},
  },
  {
    "clangd",
    for_cat = "C",
    lsp = {},
  },
  {
    "cmake",
    for_cat = "C",
    lsp = {},
  },
  {
    "cssls",
    for_cat = "web.HTML",
    lsp = {},
  },
  {
    "eslint",
    for_cat = "web.HTML",
    lsp = {},
  },
  {
    "jsonls",
    for_cat = "data",
    lsp = {},
  },
  {
    "yamlls",
    for_cat = "data",
    lsp = {
      filetypes = { "yaml", "yml" },
      settings = {
        yaml = {
          schemas = {
            ["http://json.schemastore.org/kustomization"] = "kustomization.yaml",
            ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master"] = "/*.k8s.yaml",
          },
        },
        redhat = {
          telemetry = {
            enabled = false,
          },
        },
      },
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
