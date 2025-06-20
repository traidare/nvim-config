return {
  "conform.nvim",
  for_cat = "general.core",
  cmd = { "ConformInfo", "Format" },
  keys = {
    { "<leader>f", desc = "[F]ormat [F]ile" },
  },
  after = function(_)
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        bash = { "shfmt", "shellharden" },
        c = { "clang_format" },
        cmake = { "cmake_format" }, -- FIXME
        cpp = { "clang_format" },
        css = { "prettierd", "prettier", stop_after_first = true },
        go = { "gofumpt", lsp_format = "first" },
        html = { "superhtml", lsp_format = "first" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
        nix = { "alejandra" },
        nu = { "nufmt" },
        python = { "ruff_format" },
        racket = { lsp_format = "first" },
        sh = { "shfmt", "shellharden" },
        sql = { "sqruff" },
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
        prettier = {
          prepend_args = {
            "--tab-width=2",
            "--no-semi",
          },
        },
        shfmt = {
          append_args = {
            "-i",
            "2",
            "-ci",
          },
        },
        stylua = {
          prepend_args = {
            "--indent-type=spaces",
            "--indent-width=2",
          },
        },
        tex_fmt = {
          command = "tex-fmt",
          args = {
            "--quiet",
            "--stdin",
            "--tabsize",
            "2",
            "--nowrap",
          },
        },
      },

      default_format_opts = {
        lsp_format = "fallback",
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      conform.format({
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "[F]ormat [F]ile" })

    vim.api.nvim_create_user_command("Format", function(opts)
      local formatter = opts.args

      if formatter == "" then
        conform.format()
      elseif formatter:lower() == "lsp" then
        conform.format({ formatters = nil, lsp_format = "prefer" })
      else
        conform.format({ formatters = { formatter } })
      end
    end, { nargs = "?", desc = "Format buffer with specified formatter" })
  end,
}
