return {
    {
        "go.nvim",
        for_cat = "go",
        --event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        on_require = { "go-nvim", },
        after = function()
            require("go").setup()
        end,
    },
}
