{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nix-wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Keep existing plugin inputs with plugins- prefix
    plugins-nvim-luaref = {
      url = "github:milisims/nvim-luaref";
      flake = false;
    };
    plugins-luasnip-latex-snippets = {
      url = "github:iurimateus/luasnip-latex-snippets.nvim";
      flake = false;
    };
    plugins-sqls = {
      url = "github:nanotee/sqls.nvim";
      flake = false;
    };
  };

  outputs = {self, ...} @ inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (
      {lib, ...}: {
        imports = [inputs.nix-wrapper-modules.flakeModules.default];
        systems = ["x86_64-linux" "aarch64-linux"];

        flake = let
          filterCats = enabled:
            lib.genAttrs (builtins.attrNames self.wrappers.default.settings.cats)
            (name: builtins.elem name enabled);
        in {
          overlays.default = final: _: {
            nvim = self.wrappers.default.wrap {pkgs = final;};
          };

          wrappers = rec {
            default = lib.modules.importApply ./module.nix inputs;
            nvim = default;
            nvim-testing = {
              imports = [default];
              binName = "nvim-testing";
              settings.test_mode = true;
            };
            # Server variant (Basic editing)
            nvim-small = {
              imports = [default];
              binName = "nvim-small";
              settings.cats = filterCats ["general" "theme" "treesitter" "core" "bash" "serde"];
            };
            # Minimal variant
            nvim-minimal = {
              imports = [default];
              binName = "nvim-minimal";
              settings.cats = filterCats ["general" "theme"];
            };
          };
        };
      }
    );
}
