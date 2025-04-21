return {
	"conform.nvim",
	for_cat = "general.core",
	cmd = { "ConformInfo" },
	-- event = "",
	-- ft = "",
	keys = {
		{ "<leader>f", desc = "[F]ormat [F]ile" },
	},
	-- colorscheme = "",
	after = function(_)
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				c = { "clang_format" },
				cmake = { "cmake_format" }, -- FIXME
				cpp = { "clang_format" },
				go = { "goimports", "gofmt" }, -- "golint"
				javascript = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				lua = { "stylua" },
				nix = { "alejandra" },
				python = { "isort", "black" },
				tex = { "tex_fmt" },
                nu = { "nufmt" },
                yaml = { "yamlfmt" },
			},

			formatters = {
				alejandra = {
					args = "--quiet",
				},
				tex_fmt = {
					command = "tex-fmt",
					args = {
						"--quiet",
						"--stdin",
						"--tabsize",
						"4",
						"--nowrap",
					},
				},
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "[F]ormat [F]ile" })
	end,
}
