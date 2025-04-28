local gknapsettings = {
	htmloutputext = "html",
	htmltohtml = "none",
	htmltohtmlviewerlaunch = "falkon %outputfile%",
	htmltohtmlviewerrefresh = "none",

	mdoutputext = "html",

	mdtohtml = "pandoc --standalone %docroot% -o %outputfile% -V mainfont:sans-serif",
	mdtohtmlviewerlaunch = "falkon %outputfile%",
	mdtohtmlviewerrefresh = "none",

    -- TODO: create and open files in /tmp
	mdtopdf = "pandoc %docroot% -o %outputfile% --pdf-engine=lualatex --template eisvogel --listings -V lang=de -V disable-header-and-footer=true",
	-- -V colorlinks=true -V linkcolor=blue
	-- --pdf-engine-opt=STRING
	--mdtopdfviewerlaunch = "sioyek --new-window %outputfile%",
    mdtopdfviewerlaunch = "mupdf %outputfile%",
	mdtopdfviewerrefresh = "none",

    -- TODO: create and open files in /tmp
	texoutputext = "pdf",
	textopdf = "lualatex -interaction=batchmode -synctex=1 --output-format=pdf %docroot%",
	--textopdfviewerlaunch = "sioyek --inverse-search 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,%3)\"' --new-window %outputfile%",
	--textopdfviewerlaunch = "mupdf %outputfile%",
	textopdfviewerlaunch = "evince %outputfile%",
	textopdfviewerrefresh = "none",
	--textopdfforwardjump = "sioyek --inverse-search 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%1'\"'\"',%2,%3)\"' --reuse-window --forward-search-file %srcfile% --forward-search-line %line% %outputfile%",
	textopdfforwardjump = "false",
	textopdfshorterror = 'A=%outputfile% ; LOGFILE="${A%.pdf}.log" ; rubber-info "$LOGFILE" 2>&1 | head -n 1',
	delay = 150,
}

return {
	{
		"knap",
		for_cat = { cat = "gui", default = false },
		-- cmd = { "" },
		-- event = "",
		on_require = { "knap" },
		keys = {
			-- Processes the document once, and refreshes the view
			{
				"<leader>kr",
				function()
					require("knap").process_once()
				end,
				mode = { "n" },
			},

			-- Closes the viewer application, and allows settings to be reset
			{
				"<leader>kq",
				function()
					require("knap").close_viewer()
				end,
				mode = { "n" },
			},

			-- Toggles the auto-processing on and off
			--{ '<leader>ks', function() require("knap").toggle_autopreviewing() end, mode = {"n"}, },

			-- Invokes a SyncTeX forward search, or similar, where appropriate
			{
				"<leader>k*",
				function()
					require("knap").forward_jump()
				end,
				mode = { "n" },
			},
		},
		before = function(_)
			gknapsettings.markdownoutputext = gknapsettings.mdoutputext
			gknapsettings.markdowntohtml = gknapsettings.mdtohtml
			gknapsettings.markdowntohtmlviewerlaunch = gknapsettings.mdtohtmlviewerlaunch
			gknapsettings.markdowntohtmlviewerrefresh = gknapsettings.mdtohtmlviewerrefresh
			gknapsettings.markdowntohtml = gknapsettings.mdtohtml
			gknapsettings.markdowntopdf = gknapsettings.mdtopdf
			gknapsettings.markdowntopdfviewerlaunch = gknapsettings.mdtopdfviewerlaunch
			gknapsettings.markdowntopdfviewerrefresh = gknapsettings.mdtopdfviewerrefresh
			vim.g.knap_settings = gknapsettings
		end,
	},
}
