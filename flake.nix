{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    lze = {
      url = "github:BirdeeHub/lze";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lzextras = {
      url = "github:BirdeeHub/lzextras";
      inputs.lze.follows = "lze";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plugins-diagflow = {
      url = "github:dgagn/diagflow.nvim";
      flake = false;
    };

    nix-common = {
      url = "github:traidare/nix-common";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (inputs.nixCats) utils;
    luaPath = "${./.}";
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    extra_pkg_config = {
      # allowUnfree = true;
      doCheck = false; # <- Skip long python testing
    };
    dependencyOverlays =
      #(import ./packages inputs) ++
      [
        # This overlay grabs all the inputs named in the format
        # `plugins-<pluginName>`
        # Once we add this overlay to our nixpkgs, we are able to
        # use `pkgs.neovimPlugins`, which is a set of our plugins.
        (utils.standardPluginOverlay inputs)
        # add any other flake overlays here.
        inputs.nix-common.overlays.packages

        # when other people mess up their overlays by wrapping them with system,
        # you may instead call this function on their overlay.
        # it will check if it has the system in the set, and if so return the desired overlay
        # (utils.fixSystemizedOverlay inputs.codeium.overlays
        #   (system: inputs.codeium.overlays.${system}.default)
        # )
      ];

    categoryDefinitions = {
      categories,
      extra,
      mkNvimPlugin,
      name,
      pkgs,
      settings,
      ...
    } @ packageDef: {
      sharedLibraries = {
        general = with pkgs; [];
      };

      python3.libraries = {
        python = py:
          with py; [
            debugpy
            pytest
            python-lsp-ruff
            python-lsp-server
          ];
      };

      lspsAndRuntimeDeps = with pkgs; {
        portableExtras = [
          coreutils-full
          nix
          wl-clipboard
        ];
        general = {
          bash = [
            bash-language-server
            shellcheck
            shellharden
            shfmt
          ];
        };
        go = [
          delve
          go
          go-tools
          gofumpt
          golangci-lint
          golint
          gopls
          gotools
        ];
        web = {
          HTML = [
            superhtml
            vscode-langservers-extracted
          ];
          JS = with nodePackages; [
            typescript-language-server
            eslint
            prettier
          ];
        };
        rust = [
          rustup
          llvmPackages.bintools
          lldb
        ];
        lua = [
          lua-language-server
          stylua
        ];
        nix = [
          alejandra
          nil
          nix-doc
          nixd
        ];
        nu = [
          nufmt
          nushell
        ];
        python = [
          ruff
        ];
        C = [
          clang-tools
          cmake
          cmake-format
          cmake-language-server
          cpplint
          valgrind
        ];
        data = [
          vscode-langservers-extracted
          yaml-language-server
          yamlfmt
        ];
        docker = [
          docker-compose-language-service
          dockerfile-language-server-nodejs
        ];
        tex = [
          pandoc
          tex-fmt
          texlab
        ];
        gui = [
          pandoc
        ];
      };

      startupPlugins = with pkgs.vimPlugins; {
        general = [
          lze
          inputs.lzextras.packages.${pkgs.system}.default
        ];
        theme = [no-clown-fiesta-nvim];
        treesitter = builtins.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins;
      };

      optionalPlugins = with pkgs.vimPlugins; {
        general = {
          notes = [
            neorg
            render-markdown-nvim
          ];
          cmp = [
            blink-cmp
          ];
          core = [
            conform-nvim
            nvim-lspconfig
            pkgs.neovimPlugins.diagflow
            sort-nvim
          ];
        };
        go = [
          go-nvim
          nvim-dap-go
        ];
        gui = [
          knap
        ];
        python = [
          nvim-dap-python
        ];
        debug = [
          nvim-dap
          nvim-dap-ui
          nvim-dap-virtual-text
        ];
        treesitter = [
          nvim-treesitter
          nvim-treesitter-textobjects
        ];
        extra = [
          which-key-nvim
        ];
      };
    };

    packageDefinitions = import ./nvims.nix inputs;
    defaultPackageName = "nvim-nixcats";
  in
    forEachSystem (system: let
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions;
      defaultPackage = nixCatsBuilder defaultPackageName;
      # this is just for using utils such as pkgs.mkShell
      # The one used to build neovim is resolved inside the builder
      # and is passed to our categoryDefinitions and packageDefinitions
      pkgs = import nixpkgs {inherit system;};
    in {
      # these outputs will be wrapped with ${system} by utils.eachSystem

      # this will make a package out of each of the packageDefinitions defined above
      # and set the default package to the one passed in here.
      packages = utils.mkAllWithDefault defaultPackage;

      # choose your package for devShell
      # and add whatever else you want in it.
      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [defaultPackage];
          inputsFrom = [];
          shellHook = ''
          '';
        };
      };
    })
    // (let
      # we also export a nixos module to allow reconfiguration from configuration.nix
      nixosModule = utils.mkNixosModules {
        moduleNamespace = [defaultPackageName];
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
      # and the same for home manager
      homeModule = utils.mkHomeModules {
        moduleNamespace = [defaultPackageName];
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
    in {
      # these outputs will be NOT wrapped with ${system}

      # this will make an overlay out of each of the packageDefinitions defined above
      # and set the default overlay to the one named here.
      overlays =
        utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions
        defaultPackageName;

      nixosModules.default = nixosModule;
      homeModules.default = homeModule;

      inherit utils nixosModule homeModule;
      inherit (utils) templates;
    });
}
