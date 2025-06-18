local set = vim.opt

set.mouse = ""

set.expandtab = true -- replace tabs with spaces
set.shiftwidth = 4
set.tabstop = 4

set.incsearch = true
set.hlsearch = true
set.ignorecase = true
set.smartcase = true

set.wildmode = "list:longest,full"
set.wildignorecase = true

set.number = true
set.relativenumber = true

set.linebreak = true -- break after last non-word character, instead of last character
set.cursorline = true
set.cursorlineopt = "both"

set.termguicolors = true
--set.showmode = false
set.splitbelow = true
set.splitright = true
set.scrolloff = 5
set.foldenable = false -- no automatic folding - all folds are open

-- more risky, but cleaner
set.swapfile = false
set.writebackup = false -- backup file creation before overwriting

-- set.autoindent
-- set.smartindent

if vim.g.vscode then
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
      -- Clear all autocommands related to BufModifiedSet
      vim.api.nvim_clear_autocmds({ event = "BufModifiedSet" })
    end,
  })
end
