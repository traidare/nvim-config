return {
  {
    "nvim-treesitter",
    for_cat = "general.treesitter",
    event = "DeferredUIEnter",
    dep_of = { "go.nvim" },
    load = function(name)
      require("config.utils").multi_packadd({ name, "nvim-treesitter-textobjects" })
    end,
    after = function(_)
      vim.defer_fn(function()
        require("nvim-treesitter.configs").setup({
          highlight = { enable = true },
          indent = { enable = false },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<M-t>",
              node_incremental = "<M-t>",
              scope_incremental = "<M-T>",
              node_decremental = "<M-r>",
            },
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["ab"] = "@codeblock.outer",
                ["ib"] = "@codeblock.inner",
              },
            },
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
              goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
              goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
              goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
            },
            swap = {
              enable = true,
              swap_next = { ["<leader>a"] = "@parameter.inner" },
              swap_previous = { ["<leader>A"] = "@parameter.inner" },
            },
          },
        })
      end, 0)
    end,
  },
}
