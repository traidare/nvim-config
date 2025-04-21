vim.g.mapleader = " "
vim.g.maplocalleader = " "

if not vim.g.vscode then
	require("config")
else
	require("config.vscode")
end
