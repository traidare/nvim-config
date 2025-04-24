if not vim.g.vscode then
  require("config.plugins.theme")
end

local plugins = {
  --{ import = "config.plugins.completion", enabled = nixCats('general.cmp'), },
  --{ import = "config.plugins.go", vscode = false },
  --{ import = "config.plugins.which-key", vscode = true },
  { import = "config.plugins.knap", vscode = false },
  { import = "config.plugins.treesitter", vscode = true },
  { import = "config.plugins.sort", vscode = true },
}

return vim.tbl_filter(function(plugin)
  return not vim.g.vscode or plugin.vscode
end, plugins)
