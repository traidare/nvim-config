return {
  { "ts_ls", for_cat = "web.JS", lsp = {} },
  { "cssls", for_cat = "web.HTML", lsp = {} },
  { "eslint", for_cat = "web.HTML", lsp = {} },
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
