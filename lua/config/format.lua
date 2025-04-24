return {
  "conform.nvim",
  for_cat = "general.core",
  cmd = { "ConformInfo" },
  -- event = "",
  -- ft = "",
  keys = {
    { "<leader>f", desc = "[F]ormat [F]ile" },
  },
  -- colorscheme = "",
  after = function(_)
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        c = { "clang_format" },
        cmake = { "cmake_format" }, -- FIXME
        cpp = { "clang_format" },
        go = { "gofumpt", lsp_format = "first" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
        nix = { "alejandra" },
        nu = { "nufmt" },
        python = { "ruff_format" },
        tex = { "tex_fmt" },
        yaml = { "yamlfmt" },
      },

      formatters = {
        alejandra = {
          prepend_args = { "--quiet" },
        },
        clang_format = {
          prepend_args = function()
            local style = {
              BasedOnStyle = "Google",
              ---
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
            }

            -- Convert the style table to a JSON string
            local style_json = vim.fn.json_encode(style)

            -- Return the command with the style
            return { "--style=" .. style_json }
          end,
        },
        tex_fmt = {
          command = "tex-fmt",
          args = {
            "--quiet",
            "--stdin",
            "--tabsize",
            "4",
            "--nowrap",
          },
        },
        stylua = {
          prepend_args = {
            "--indent-type=spaces",
            "--indent-width=2",
          },
        },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "[F]ormat [F]ile" })
  end,
}
