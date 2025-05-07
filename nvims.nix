inputs: let
  inherit (inputs.nixCats) utils;

  default_settings = { pkgs, name, ... }@misc: {
    extraName = "nvim";
    configDirName = "nvim-nixcats";
    hosts = {
      python3.enable = true;
    };
  };

  default_categories = { pkgs, ... }@misc: {
    C = true;
    data = true;
    debug = false;
    extra = true;
    general = true;
    go = true;
    gui = true;
    lua = true;
    nix = true;
    nu = true;
    python = true;
    rust = false;
    tex = true;
    theme = true;
    treesitter = true;
    web = true;
  };

  default_extra = { pkgs, ... }@misc: {
    nixdExtras = {
      nixpkgs = inputs.nixpkgs.outPath;
      #nixos_options = ''(builtins.getFlake "${inputs.self.outPath}").legacyPackages.${pkgs.system}.nixosConfigurations."".options'';
    };
    # TODO: add yamlfmt configuration
  };
in {
  nvim-nixcats = args: {
    settings =
      default_settings args
      // {
        wrapRc = true;
        aliases = ["vi" "nvim"];
      };
    categories =
      default_categories args
      // {
      };
    extra =
      default_extra args
      // {
      };
  };

  nvim-testing = args: {
    settings =
      default_settings args
      // {
        wrapRc = false;
        aliases = ["tnvim"];
      };
    categories =
      default_categories args
      // {
      };
    extra =
      default_extra args
      // {
      };
  };
}
