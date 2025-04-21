require("no-clown-fiesta").setup({
	transparent = false, -- Enable this to disable the bg color
	styles = {
		-- You can set any of the style values specified for `:h nvim_set_hl`
		comments = {},
		keywords = {},
		functions = {},
		variables = {},
		--type = { bold = true },
		--lsp = { underline = true }
	},
})
vim.cmd.colorscheme("no-clown-fiesta")

return {
	--{ import = "config.plugins.completion", enabled = nixCats('general.cmp'), },
	{ import = "config.plugins.go" },
	{ import = "config.plugins.knap" },
	{ import = "config.plugins.treesitter" },
	{ import = "config.plugins.which-key" },
	{ import = "config.plugins.sort" },
}
