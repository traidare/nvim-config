require("lze").register_handlers({
	require("nixCatsUtils.lzUtils").for_cat,
	require("lzextras").lsp,
})
require("lze").load({
	{ import = "config.plugins" },
	{ import = "config.lsps" },
	--{ import = "config.debug",  enabled = nixCats("debug") },
	{ import = "config.format" },
	--{ import = "config.lint" },
})

require("config.options")
require("config.mappings")
