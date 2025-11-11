local knap_settings = {
  -- HTML settings
  htmloutputext = "html",
  htmltohtml = "none",
  htmltohtmlviewerlaunch = "falkon %outputfile%",
  htmltohtmlviewerrefresh = "none",

  -- Markdown settings
  mdoutputext = "html",
  mdtohtml = "pandoc --standalone %docroot% -o %outputfile% -V mainfont:sans-serif",
  mdtohtmlviewerlaunch = "falkon %outputfile%",
  mdtohtmlviewerrefresh = "none",
  mdtopdf = "pandoc %docroot% -o %outputfile% --pdf-engine=lualatex --template eisvogel --listings -V lang=de -V disable-header-and-footer=true",
  mdtopdfviewerlaunch = "sioyek --new-window %outputfile%",
  mdtopdfviewerrefresh = "none",

  -- LaTeX settings
  texoutputext = "pdf",
  textopdf = "lualatex -interaction=batchmode -synctex=1 --output-format=pdf %docroot%",
  textopdfviewerlaunch = "sioyek --inverse-search 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,%3)\"' --new-window %outputfile%",
  textopdfviewerrefresh = "none",
  textopdfforwardjump = "sioyek --inverse-search 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,%3)\"' --reuse-window --forward-search-file %srcfile% --forward-search-line %line% %outputfile%",
  textopdfshorterror = 'A=%outputfile% ; LOGFILE="${A%.pdf}.log" ; rubber-info "$LOGFILE" 2>&1 | head -n 1',
  delay = 150,
}

-- Copy md settings to markdown (knap compatibility)
for key, value in pairs(knap_settings) do
  if key:match("^md") then
    knap_settings["markdown" .. key:sub(3)] = value
  end
end

return {
  {
    "knap",
    for_cat = { cat = "tex", default = false },
    on_require = { "knap" },
    keys = {
      { "<leader>kr", function() require("knap").process_once() end, desc = "Knap process once" },
      { "<leader>kq", function() require("knap").close_viewer() end, desc = "Knap close viewer" },
      { "<leader>k*", function() require("knap").forward_jump() end, desc = "Knap forward jump" },
    },
    before = function(_)
      vim.g.knap_settings = knap_settings
    end,
  },
}
