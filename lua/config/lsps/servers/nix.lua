local nixpkgs_path = nix.info("nixdExtras", "nixpkgs")

return {
  {
    "nil_ls",
    enabled = not nix.isNix,
    lsp = {},
  },
  {
    "nixd",
    for_cat = "nix",
    lsp = {
      settings = {
        nixd = {
          nixpkgs = {
            expr = nixpkgs_path and [[import (builtins.getFlake "]] .. nixpkgs_path .. [[") { }]]
              or "import <nixpkgs> {}",
          },
          diagnostic = {
            suppress = { "sema-escaping-with" },
          },
        },
      },
    },
  },
}
