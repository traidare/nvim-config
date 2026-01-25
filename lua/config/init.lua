vim.g.mapleader = " "
vim.g.maplocalleader = " "

_G.nix = require("nix")

local handlers = require("nix.handlers")

require("lze").register_handlers({
  handlers.for_cat,
  handlers.auto_enable,
  require("lzextras").lsp,
})

local modules = {
  { import = "config.plugins", vscode = true },
  { import = "config.lsps", vscode = false },
  { import = "config.format", vscode = true },
}

require("lze").load(vim.tbl_filter(function(module)
  return not vim.g.vscode or module.vscode
end, modules))

require("config.options")
require("config.mappings")
