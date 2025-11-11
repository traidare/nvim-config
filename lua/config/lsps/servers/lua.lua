return {
  {
    "lua_ls",
    enabled = nixCats("lua") or nixCats("neonixdev"),
    lsp = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          formatters = { ignoreComments = true },
          signatureHelp = { enabled = true },
          diagnostics = {
            globals = { "nixCats", "vim", "make_test" },
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
            path = (nixCats.pawsible({ "allPlugins", "start", "luvit-meta" }) or "luvit-meta") .. "/library",
          },
          { words = { "nixCats" }, path = (nixCats.nixCatsPath or "") .. "/lua" },
        },
      })
    end,
  },
}
