local set = vim.opt

-- Disable mouse
set.mouse = ""

-- Tab settings
set.expandtab = true
set.shiftwidth = 4
set.tabstop = 4

-- Search settings
set.incsearch = true
set.hlsearch = true
set.ignorecase = true
set.smartcase = true

-- Wildmenu settings
set.wildmode = "list:longest,full"
set.wildignorecase = true

-- Line numbers
set.number = true
set.relativenumber = true

-- UI settings
set.linebreak = true
set.cursorline = true
set.cursorlineopt = "both"
set.termguicolors = true
set.splitbelow = true
set.splitright = true
set.scrolloff = 5
set.foldenable = false

-- Disable swap and backup files
set.swapfile = false
set.writebackup = false

-- SQL completion settings
vim.g.omni_sql_default_compl_type = "syntax"

if vim.g.vscode then
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
      -- Clear all autocommands related to BufModifiedSet
      vim.api.nvim_clear_autocmds({ event = "BufModifiedSet" })
    end,
  })
end
