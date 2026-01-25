-- Formatters by filetype
local formatters_by_ft = {
  bash = { "shfmt", "shellharden" },
  c = { "clang_format" },
  cmake = { "cmake_format" },
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
          SpacesInParentheses = false,
          SpacesInSquareBrackets = false,
          UseTab = "Never",
        }),
      }
    end,
  },
  prettier = { prepend_args = { "--tab-width=2", "--no-semi" } },
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

    -- VSCode workaround: preserve EOF newline when formatting
    local function format_preserve_eof_newline(format_opts)
      if not vim.g.vscode then
        return conform.format(format_opts)
      end

      local buf = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local had_eof_newline = lines[#lines] == ""

      conform.format(format_opts)

      if had_eof_newline then
        lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        if lines[#lines] ~= "" then
          vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "" })
        end
      end
    end

    -- Keymap
    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      format_preserve_eof_newline({ async = false, timeout_ms = 1000 })
    end, { desc = "[F]ormat [F]ile" })

    -- Command
    vim.api.nvim_create_user_command("Format", function(opts)
      local format_opts = opts.args == "" and {}
        or opts.args:lower() == "lsp" and { formatters = nil, lsp_format = "prefer" }
        or { formatters = { opts.args } }

      format_preserve_eof_newline(format_opts)
    end, { nargs = "?", desc = "Format buffer with specified formatter" })
  end,
}
