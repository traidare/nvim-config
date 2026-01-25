local function setup_treesitter()
  local ts = require("nvim-treesitter")
  local installable = ts.get_available()

  local function try_attach(buf, lang)
    if not vim.treesitter.language.add(lang) then
      return false
    end
    vim.treesitter.start(buf, lang)
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldmethod = "expr"
    vim.o.foldlevel = 99
    return true
  end

  vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
      local lang = vim.treesitter.language.get_lang(ev.match)
      if not lang then
        return
      end

      if not try_attach(ev.buf, lang) and vim.tbl_contains(installable, lang) then
        ts.install(lang):await(function()
          try_attach(ev.buf, lang)
        end)
      end
    end,
  })
end

local function setup_textobjects()
  require("nvim-treesitter-textobjects").setup({
    select = {
      lookahead = true,
      selection_modes = { ["@parameter.outer"] = "v", ["@function.outer"] = "V" },
    },
  })

  local select = require("nvim-treesitter-textobjects.select").select_textobject
  local move = require("nvim-treesitter-textobjects.move")
  local swap = require("nvim-treesitter-textobjects.swap")

  local function sel(capture)
    return function()
      select(capture, "textobjects")
    end
  end

  -- Text object selection: a=parameter, f=function, c=class, b=codeblock
  for _, obj in ipairs({ "a:parameter", "f:function", "c:class", "b:codeblock" }) do
    local key, name = obj:match("(.):(.+)")
    vim.keymap.set({ "x", "o" }, "a" .. key, sel("@" .. name .. ".outer"), { desc = "Around " .. name })
    vim.keymap.set({ "x", "o" }, "i" .. key, sel("@" .. name .. ".inner"), { desc = "Inside " .. name })
  end

  -- Movement: m=function, ]=class
  local movements = {
    { "]m", move.goto_next_start, "@function.outer", "Next function start" },
    { "]M", move.goto_next_end, "@function.outer", "Next function end" },
    { "]]", move.goto_next_start, "@class.outer", "Next class start" },
    { "][", move.goto_next_end, "@class.outer", "Next class end" },
    { "[m", move.goto_previous_start, "@function.outer", "Prev function start" },
    { "[M", move.goto_previous_end, "@function.outer", "Prev function end" },
    { "[[", move.goto_previous_start, "@class.outer", "Prev class start" },
    { "[]", move.goto_previous_end, "@class.outer", "Prev class end" },
  }
  for _, m in ipairs(movements) do
    vim.keymap.set({ "n", "x", "o" }, m[1], function()
      m[2](m[3], "textobjects")
    end, { desc = m[4] })
  end

  -- Swap parameters
  vim.keymap.set("n", "<leader>a", function()
    swap.swap_next("@parameter.inner", "textobjects")
  end, { desc = "Swap next param" })
  vim.keymap.set("n", "<leader>A", function()
    swap.swap_previous("@parameter.inner", "textobjects")
  end, { desc = "Swap prev param" })
end

return {
  {
    "nvim-treesitter",
    for_cat = "treesitter",
    lazy = false,
    dep_of = { "go.nvim" },
    after = setup_treesitter,
  },
  {
    "nvim-treesitter-textobjects",
    for_cat = "treesitter",
    lazy = false,
    before = function()
      -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main?tab=readme-ov-file#using-a-package-manager
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      --vim.g.no_plugin_maps = true
    end,
    after = setup_textobjects,
  },
}
