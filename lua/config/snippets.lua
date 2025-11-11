local ls = require("luasnip")

-- Load VSCode-style snippets
require("luasnip.loaders.from_vscode").lazy_load()
ls.config.setup({})

-- Navigate snippet choices
vim.keymap.set({ "i", "s" }, "<M-n>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

-- Custom snippets
ls.add_snippets("all", {
  ls.snippet("genip", {
    ls.function_node(function()
      return vim.fn.system("gen-IP4")
    end),
  }),
})
