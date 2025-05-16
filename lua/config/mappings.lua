local map = vim.keymap.set

map("n", "i", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true, desc = "Properly indent on empty line when using insert" })

map("n", "<leader>n", ":set norelativenumber!<CR>")
map("n", "<leader>y", '"+y')
map("n", "<leader>d", '"+d')
map("n", "<leader>p", '"+p')

map("i", "<C-,><C-l>", [[<C-o>:r !uuidgen|sed "s/.*/&/"|tr "[A-Z]" "[a-z]"<CR><C-o>k<C-o>J<C-o>x<C-o>$]]) -- insert random generated UUID - https://gist.github.com/goude/b44b9d3938d3d30d8873f34fe2f92057 / https://www.grailbox.com/2021/07/insert-uuids-in-vim-neovim/ -- also probably doable with '/normal' instead of '<C-o>'

map("v", ".", ":normal .<CR>") -- allow the . to execute once for each line of a visual selection

-- CMDLINE
vim.keymap.set("c", "<A-v>", "<C-f>")
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-b>", "<Left>")
vim.keymap.set("c", "<C-f>", "<Right>")
vim.keymap.set("c", "<A-b>", "<S-Left>")
vim.keymap.set("c", "<A-f>", "<S-Right>")

if vim.g.vscode then
  local vscode = require("vscode")

  --map('i', '<A-o>', '<Esc>o')
  --map('i', '<AS-o>', '<Esc>O')
  --
  --map('n', '<C-d>', 'k') -- Move the cursor after scrolling
  --map('n', '<C-u>', 'j') -- Move the cursor after scrolling

  -- Fix https://github.com/vscode-neovim/vscode-neovim/discussions/2202
  -- defined here https://github.com/vscode-neovim/vscode-neovim/blob/master/runtime/vscode/overrides/vscode-window-commands.vim

  --vim.keymap.del({ 'n', 'x' }, '<C-w><C-h>')
  --vim.keymap.del({ 'n', 'x' }, '<C-w><C-l>')

  vim.keymap.set({ "n", "x" }, "<C-w><A-h>", function()
    vscode.action("workbench.action.moveEditorToLeftGroup")
  end)
  vim.keymap.set({ "n", "x" }, "<C-w><A-l>", function()
    vscode.action("workbench.action.moveEditorToRightGroup")
  end)
end
