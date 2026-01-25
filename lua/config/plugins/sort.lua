return {
  {
    "sort.nvim",
    for_cat = "core",
    cmd = { "Sort" },
    after = function()
      require("sort").setup({
        delimiters = { ",", "|", ";", ":", "s", "t" },
      })
    end,
  },
}
