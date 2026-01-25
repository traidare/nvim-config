inputs: {
  config,
  lib,
  pkgs,
  wlib,
  ...
}: {
  imports = [wlib.wrapperModules.neovim];

  options = {
    nvim-lib = {
      pluginsFromPrefix = lib.mkOption {
        type = lib.types.raw;
        readOnly = true;
        default = prefix: inputs:
          lib.pipe inputs [
            builtins.attrNames
            (builtins.filter (s: lib.hasPrefix prefix s))
            (map (input: let
              name = lib.removePrefix prefix input;
            in {
              inherit name;
              value = config.nvim-lib.mkPlugin name inputs.${input};
            }))
            builtins.listToAttrs
          ];
      };
      neovimPlugins = lib.mkOption {
        type = lib.types.raw;
        default = config.nvim-lib.pluginsFromPrefix "plugins-" inputs;
        description = "Set of plugins built from flake inputs with `plugins-` prefix";
      };
    };

    settings = {
      test_mode = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      wrapped_config = lib.mkOption {
        type = wlib.types.stringable;
        default = ./.;
      };
      unwrapped_config = lib.mkOption {
        type = wlib.types.nonEmptyLine;
        default = "/home/user/.config/nvim-config";
      };
      # Category flags - accessible from Lua via nix.cat()
      cats = lib.mkOption {
        type = lib.types.attrsOf lib.types.bool;
        default = {};
        description = "Category enable flags - accessible from Lua";
      };
    };
  };

  # ===== postpkgs support =====
  config.specMods = {
    options.postpkgs = lib.mkOption {
      type = lib.types.listOf wlib.types.stringable;
      default = [];
      description = "Packages to add to PATH for this spec";
    };
  };
  config.suffixVar = let
    autodeps = config.specCollect (acc: v: acc ++ (v.postpkgs or [])) [];
  in
    lib.optional (autodeps != []) {
      name = "POSTPKGS_ADDITIONS";
      data = ["PATH" ":" "${lib.makeBinPath (lib.unique autodeps)}"];
    };

  # ===== BASIC SETTINGS =====
  config.settings.config_directory =
    if config.settings.test_mode
    then config.settings.unwrapped_config
    else config.settings.wrapped_config;

  config.settings.dont_link = config.binName != "nvim";
  config.settings.aliases = lib.mkIf (config.binName == "nvim") ["vi"];
  config.env.NVIM_APPNAME = "nvim";

  # ===== DEFAULT CATEGORY FLAGS =====
  config.settings.cats = {
    general = lib.mkDefault true;
    theme = lib.mkDefault true;
    treesitter = lib.mkDefault true;
    cmp = lib.mkDefault true;
    core = lib.mkDefault true;
    bash = lib.mkDefault true;
    lua = lib.mkDefault true;
    nix = lib.mkDefault true;
    python = lib.mkDefault true;
    rust = lib.mkDefault true;
    go = lib.mkDefault true;
    web = lib.mkDefault true;
    tex = lib.mkDefault true;
    sql = lib.mkDefault true;
    docker = lib.mkDefault true;
    serde = lib.mkDefault true;
    nu = lib.mkDefault true;
    racket = lib.mkDefault true;
    debug = lib.mkDefault false;
    notes = lib.mkDefault true;
    other = lib.mkDefault true;
    C = lib.mkDefault true;
  };

  # ===== RUNTIME INFO =====
  config.info.nixdExtras = lib.mkIf (config.settings.cats.nix or true) {
    nixpkgs = inputs.nixpkgs.outPath;
  };

  # ===== PYTHON HOST =====
  config.hosts.python3.withPackages = lib.mkIf (config.settings.cats.python or true) (py:
    with py; [
      debugpy
      pytest
      python-lsp-ruff
      python-lsp-server
    ]);

  # ===== SPECS =====
  config.specs.general = lib.mkIf (config.settings.cats.general or true) {
    data = with pkgs.vimPlugins; [
      lze
      lzextras
    ];
    postpkgs = with pkgs; [
      tree-sitter
      ripgrep
      fd
    ];
  };

  config.specs.theme =
    lib.mkIf (config.settings.cats.theme or true)
    pkgs.vimPlugins.no-clown-fiesta-nvim;

  config.specs.treesitter = lib.mkIf (config.settings.cats.treesitter or true) {
    lazy = true;
    data = with pkgs.vimPlugins; [
      nvim-treesitter-textobjects
      nvim-treesitter.withAllGrammars
    ];
  };

  config.specs.cmp = lib.mkIf (config.settings.cats.cmp or true) {
    lazy = true;
    data = with pkgs.vimPlugins; [
      blink-cmp
      blink-compat
      cmp-cmdline
      colorful-menu-nvim
      luasnip
    ];
  };

  config.specs.core = lib.mkIf (config.settings.cats.core or true) {
    lazy = true;
    data = with pkgs.vimPlugins; [
      conform-nvim
      diagflow-nvim
      nvim-lspconfig
      sort-nvim
    ];
  };

  config.specs.bash = lib.mkIf (config.settings.cats.bash or true) {
    data = null;
    postpkgs = with pkgs; [
      bash-language-server
      shellcheck
      shellharden
      shfmt
    ];
  };

  config.specs.lua = lib.mkIf (config.settings.cats.lua or true) {
    lazy = true;
    data = with pkgs.vimPlugins; [
      lazydev-nvim
      luvit-meta
      config.nvim-lib.neovimPlugins.nvim-luaref
    ];
    postpkgs = with pkgs; [
      lua-language-server
      stylua
    ];
  };

  config.specs.nix = lib.mkIf (config.settings.cats.nix or true) {
    data = null;
    postpkgs = with pkgs; [
      alejandra
      nil
      nix-doc
      nixd
    ];
  };

  config.specs.python = lib.mkIf (config.settings.cats.python or true) {
    lazy = true;
    data = [pkgs.vimPlugins.nvim-dap-python];
    postpkgs = with pkgs; [
      ruff
    ];
  };

  config.specs.rust = lib.mkIf (config.settings.cats.rust or true) {
    data = null;
    postpkgs = with pkgs; [
      rust-analyzer
      rustfmt
    ];
  };

  config.specs.go = lib.mkIf (config.settings.cats.go or true) {
    lazy = true;
    data = with pkgs.vimPlugins; [
      go-nvim
      nvim-dap-go
    ];
    postpkgs = with pkgs; [
      delve
      go
      go-tools
      gofumpt
      golangci-lint
      golint
      gopls
      gotools
    ];
  };

  config.specs.web = lib.mkIf (config.settings.cats.web or true) {
    data = null;
    postpkgs = with pkgs;
      [
        pandoc
        superhtml
        vscode-langservers-extracted
      ]
      ++ (with nodePackages; [
        typescript-language-server
        eslint
        prettier
      ]);
  };

  config.specs.tex = lib.mkIf (config.settings.cats.tex or true) {
    lazy = true;
    data = with pkgs.vimPlugins; [
      knap
      config.nvim-lib.neovimPlugins.luasnip-latex-snippets
    ];
    postpkgs = with pkgs; [
      pandoc
      tex-fmt
      texlab
    ];
  };

  config.specs.sql = lib.mkIf (config.settings.cats.sql or true) {
    lazy = true;
    data = [config.nvim-lib.neovimPlugins.sqls];
    postpkgs = with pkgs; [
      sqls
      sqruff
    ];
  };

  config.specs.docker = lib.mkIf (config.settings.cats.docker or true) {
    data = null;
    postpkgs = with pkgs; [
      docker-compose-language-service
      dockerfile-language-server
    ];
  };

  config.specs.serde = lib.mkIf (config.settings.cats.serde or true) {
    data = null;
    postpkgs = with pkgs; [
      gitlab-ci-ls
      libxml2
      vscode-langservers-extracted
      yaml-language-server
      yamlfmt
    ];
  };

  config.specs.nu = lib.mkIf (config.settings.cats.nu or true) {
    data = null;
    postpkgs = with pkgs; [
      nufmt
      nushell
    ];
  };

  config.specs.racket = lib.mkIf (config.settings.cats.racket or true) {
    data = null;
    postpkgs = with pkgs; [
      racket
    ];
  };

  config.specs.debug = lib.mkIf (config.settings.cats.debug or false) {
    lazy = true;
    data = with pkgs.vimPlugins; [
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
    ];
  };

  config.specs.notes = lib.mkIf (config.settings.cats.notes or true) {
    lazy = true;
    data = with pkgs.vimPlugins; [
      neorg
      render-markdown-nvim
    ];
    postpkgs = with pkgs; [
      pandoc
    ];
  };

  config.specs.other = lib.mkIf (config.settings.cats.other or true) {
    lazy = true;
    data = [pkgs.vimPlugins.which-key-nvim];
  };

  config.specs.C = lib.mkIf (config.settings.cats.C or true) {
    data = null;
    postpkgs = with pkgs; [
      clang-tools
      cmake
      cmake-format
      cmake-language-server
      cpplint
      valgrind
    ];
  };
}
