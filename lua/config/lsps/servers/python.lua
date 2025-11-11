return {
  {
    "pylsp",
    for_cat = "python",
    lsp = {
      cmd = { vim.g.python3_host_prog, "-m", "pylsp" },
      settings = {
        pylsp = {
          plugins = {
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
                "B", -- flake8-bugbear
                "FA", -- flake8-future-annotations
                "TID", -- flake8-tidy-imports
                "UP007", -- flake8-new-union-types equivalent rule
                "RUF", -- ruff's custom rules
              },
              ignore = {
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
}
