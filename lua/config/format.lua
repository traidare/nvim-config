-- Formatters by filetype
local formatters_by_ft = {
  bash = { "shfmt", "shellharden" },
  c = { "clang_format" },
  cpp = { "clang_format" },
  css = { "prettierd", "prettier", stop_after_first = true },
  go = { "goimports", "gofumpt" },
  html = { "superhtml", lsp_format = "first" },
  javascript = { "prettierd", "prettier", stop_after_first = true },
  javascriptreact = { "prettierd", "prettier", stop_after_first = true },
  json = { "prettierd", "prettier", stop_after_first = true },
  lua = { "stylua" },
  nix = { "alejandra" },
  nu = { "nufmt" },
  php = { "php_cs_fixer" },
  python = { "ruff_format" },
  racket = { lsp_format = "first" },
  rust = { "rustfmt" },
  sh = { "shfmt", "shellharden" },
  sql = { "sqruff" },
  tex = { "tex_fmt" },
  typescript = { "prettierd", "prettier", stop_after_first = true },
  typescriptreact = { "prettierd", "prettier", stop_after_first = true },
  xml = { "xmllint" },
  yaml = { "yamlfmt" },
}

local formatters = {
  alejandra = { prepend_args = { "--quiet" } },
  clang_format = {
    prepend_args = function()
      return {
        "--style=" .. vim.fn.json_encode({
          BasedOnStyle = "Google",
          AlignAfterOpenBracket = true,
          AlignArrayOfStructures = "Left",
          AlignConsecutiveAssignments = "AcrossComments",
          AlignConsecutiveDeclarations = "AcrossComments",
          AlignConsecutiveMacros = "AcrossComments",
          AlignEscapedNewlines = "LeftWithLastLine",
          AlignOperands = true,
          AlignTrailingComments = { Kind = "Always", OverEmptyLines = 2 },
          BreakConstructorInitializers = "AfterColon",
          ColumnLimit = 0,
          IndentWidth = 4,
          InsertNewlineAtEOF = true,
          SpacesInParentheses = false,
          SpacesInSquareBrackets = false,
          UseTab = "Never",
        }),
      }
    end,
  },
  prettier = { prepend_args = {
    "--tab-width=2",
    "--no-semi",
  } },
  shfmt = { append_args = { "-i", "2", "-ci" } },
  stylua = { prepend_args = { "--indent-type=spaces", "--indent-width=2" } },
  tex_fmt = {
    command = "tex-fmt",
    args = { "--quiet", "--stdin", "--tabsize", "2", "--nowrap" },
  },
}

return {
  "conform.nvim",
  for_cat = "core",
  cmd = { "ConformInfo", "Format" },
  keys = { { "<leader>f", desc = "[F]ormat [F]ile" } },
  after = function(_)
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = formatters_by_ft,
      formatters = formatters,
      default_format_opts = { lsp_format = "fallback" },
    })

    local function vscode_format()
      require("vscode").action("runCommands", {
        args = {
          commands = {
            "editor.action.organizeImports",
            "editor.action.formatDocument",
          },
        },
      })
    end

    -- Keymap: use VSCode's native formatter in VSCode, conform otherwise
    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      if vim.g.vscode then
        vscode_format()
      else
        conform.format({ async = false, timeout_ms = 1000 })
      end
    end, { desc = "[F]ormat [F]ile" })

    -- Command
    vim.api.nvim_create_user_command("Format", function(opts)
      if vim.g.vscode then
        vscode_format()
        return
      end

      conform.format(
        opts.args == "" and {}
          or opts.args:lower() == "lsp" and { formatters = nil, lsp_format = "prefer" }
          or { formatters = { opts.args } }
      )
    end, { nargs = "?", desc = "Format buffer with specified formatter" })
  end,
}
