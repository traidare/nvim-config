vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lze").register_handlers({
  require("nixCatsUtils.lzUtils").for_cat,
  require("lzextras").lsp,
})

local modules = {
  { import = "config.plugins", vscode = true },
  { import = "config.lsps", vscode = false },
  --{ import = "config.debug", enabled = nixCats("debug"), vscode = false },
  { import = "config.format", vscode = true },
}

require("lze").load(vim.tbl_filter(function(module)
  return not vim.g.vscode or module.vscode
end, modules))

require("config.options")
require("config.mappings")
