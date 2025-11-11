local catUtils = require("nixCatsUtils")

return {
  {
    "nil_ls",
    enabled = not catUtils.isNixCats,
    lsp = {},
  },
  {
    "nixd",
    enabled = catUtils.isNixCats,
    lsp = {
      settings = {
        nixd = {
          nixpkgs = {
            expr = [[import (builtins.getFlake "]] .. nixCats.extra("nixdExtras.nixpkgs") .. [[") { }   ]],
          },
          diagnostic = {
            suppress = { "sema-escaping-with" },
          },
        },
      },
    },
  },
}
