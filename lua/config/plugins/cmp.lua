local load_w_after = require("lzextras").loaders.with_after
return {
  {
    "cmp-cmdline",
    for_cat = "general.cmp",
    on_plugin = { "blink.cmp" },
    load = load_w_after,
  },
  {
    "blink.compat",
    for_cat = "general.cmp",
    dep_of = { "cmp-cmdline" },
  },
  {
    "luasnip",
    for_cat = "general.cmp",
    dep_of = { "blink.cmp" },
    after = function(_)
      require("config.snippets")
    end,
  },
  {
    "colorful-menu.nvim",
    for_cat = "general.cmp",
    on_plugin = { "blink.cmp" },
  },
  {
    "blink.cmp",
    for_cat = "general.cmp",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("blink.cmp").setup({
        -- See :h blink-cmp-config-keymap for configuring keymaps
        -- TODO: Make <C-p> & <C-n> use blink menu
        keymap = {
          preset = "enter",
          ["<CR>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                return cmp.accept()
              end
            end,
            "fallback",
          },
          ["<C-e>"] = { "accept", "fallback" },
          ["<C-y>"] = { "accept", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback" },
          ["<C-n>"] = { "select_next", "fallback" },
        },

        cmdline = {
          enabled = true,

          keymap = {
            preset = "cmdline",
            ["<CR>"] = { "accept", "fallback" },
            ["<C-e>"] = { "accept", "fallback" },
            ["<C-y>"] = { "accept", "fallback" },
            ["<Tab>"] = { "show", "select_next" },
            ["<S-Tab>"] = { "show", "select_prev" },
            ["<ESC>"] = {
              function(cmp)
                if cmp.is_menu_visible() then
                  cmp.cancel()
                else
                  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n", true)
                end
              end,
            },
          },

          completion = {
            list = {
              selection = {
                preselect = false,
                auto_insert = true,
              },
            },
            menu = {
              auto_show = false,
            },
            ghost_text = { -- needs noice.nvim to work
              enabled = true,
            },
          },

          sources = function()
            local type = vim.fn.getcmdtype()
            -- Search forward and backward
            if type == "/" or type == "?" then
              return { "buffer" }
            end
            -- Commands
            if type == ":" or type == "@" then
              return { "cmdline", "cmp_cmdline" }
            end
            return {}
          end,
        },

        term = {
          enabled = false,
        },

        fuzzy = {
          sorts = {
            "exact",
            -- defaults
            "score",
            "sort_text",
          },
        },

        appearance = {
          nerd_font_variant = "mono",
        },

        signature = {
          enabled = true,
          window = {
            show_documentation = true,
          },
        },

        completion = {
          list = {
            selection = {
              preselect = true,
              auto_insert = false,
            },
          },
          menu = {
            auto_show = false,
            draw = {
              columns = {
                { "label", "label_description", gap = 1 },
                { "srckind" },
              },
              treesitter = { "lsp" },
              components = {
                srckind = {
                  ellipsis = false,
                  width = { fill = true },
                  text = function(ctx)
                    return ctx.kind
                  end,
                  highlight = function(ctx)
                    return ctx.kind_hl
                  end,
                },
                label = {
                  text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
                  end,
                },
              },
            },
          },
          documentation = {
            auto_show = true,
          },
          ghost_text = {
            enabled = true,
            show_with_menu = false,
          },
        },

        snippets = {
          preset = "luasnip",
        },

        sources = {
          default = { "lsp", "path", "snippets", "buffer", "omni" },
          providers = {
            path = {
              score_offset = 50,
            },
            lsp = {
              score_offset = 40,
            },
            snippets = {
              score_offset = 40,
            },
            cmp_cmdline = {
              name = "cmp_cmdline",
              module = "blink.compat.source",
              score_offset = -100,
              opts = {
                cmp_name = "cmdline",
              },
            },
          },
        },
      })
    end,
  },
}
