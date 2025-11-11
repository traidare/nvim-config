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
        on_attach = require("config.lsps.keymaps"),
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
        placement = "top",
        scope = "line",
        show_borders = false,
        show_sign = false,
        padding_right = 1,
        gap = 3,
        update_event = { "DiagnosticChanged" },
      })
    end,
  },
}
