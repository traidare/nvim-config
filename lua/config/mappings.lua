local map = vim.keymap.set

-- Fix common typos
for _, cmd_name in ipairs({ "W", "Q", "Wq", "WQ" }) do
  vim.api.nvim_create_user_command(cmd_name, function()
    vim.cmd(cmd_name:lower())
  end, {})
end

-- Properly indent on empty line in insert mode
map("n", "i", function()
  return #vim.fn.getline(".") == 0 and [["_cc]] or "i"
end, { expr = true, desc = "Properly indent on empty line" })

-- Toggle relative line numbers
map("n", "<leader>n", ":set norelativenumber!<CR>")

-- System clipboard operations
map("n", "<leader>y", '"+y')
map("n", "<leader>d", '"+d')
map("n", "<leader>p", '"+p')

-- Insert lowercase UUID
map("i", "<C-,><C-l>", [[<C-o>:r !uuidgen|sed "s/.*/&/"|tr "[A-Z]" "[a-z]"<CR><C-o>k<C-o>J<C-o>x<C-o>$]])

-- Execute . command for each line in visual selection
map("v", ".", ":normal .<CR>")

-- Command-line navigation
map("c", "<A-v>", "<C-f>")
map("c", "<C-a>", "<Home>")
map("c", "<C-b>", "<Left>")
map("c", "<C-f>", "<Right>")
map("c", "<A-b>", "<S-Left>")
map("c", "<A-f>", "<S-Right>")

-- VSCode-specific setup
if vim.g.vscode then
  require("vscode")
end
