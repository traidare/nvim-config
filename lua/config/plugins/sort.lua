return {
    {
        "sort.nvim",
        for_cat = "general.core",
        cmd = { "Sort", },
        after = function()
            require("sort").setup({
                -- List of delimiters, in descending order of priority to automatically sort on.
                delimiters = {
                    ",",
                    "|",
                    ";",
                    ":",
                    "s", -- Space
                    "t", -- Tab
                },
            })
        end,
    },
}
