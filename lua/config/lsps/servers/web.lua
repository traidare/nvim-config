return {
  { "ts_ls", for_cat = "web", lsp = {} },
  { "cssls", for_cat = "web", lsp = {} },
  { "eslint", for_cat = "web", lsp = {} },
  {
    "html",
    for_cat = "web",
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
