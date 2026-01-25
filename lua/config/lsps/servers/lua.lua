return {
  {
    "lua_ls",
    enabled = nix.cat("lua") or nix.cat("neonixdev"),
    lsp = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          formatters = { ignoreComments = true },
          signatureHelp = { enabled = true },
          diagnostics = {
            globals = { "nixInfo", "vim", "make_test" },
            disable = { "missing-fields" },
          },
          workspace = { checkThirdParty = false, library = {} },
          completion = { callSnippet = "Replace" },
          telemetry = { enabled = false },
        },
      },
    },
  },
  {
    "lazydev.nvim",
    for_cat = "neonixdev",
    cmd = { "LazyDev" },
    ft = "lua",
    after = function(_)
      require("lazydev").setup({
        library = {
          {
            words = { "uv", "vim%.uv", "vim%.loop" },
            path = (nix.pluginPath("luvit-meta") or "luvit-meta") .. "/library",
          },
        },
      })
    end,
  },
}
