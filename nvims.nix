inputs: let
  inherit (inputs.nixCats) utils;

  default_settings = {
    pkgs,
    name,
    ...
  } @ misc: {
    wrapRc = true;
    extraName = "nvim";
    configDirName = "nvim-nixcats";
    hosts = {
      python3.enable = true;
    };
  };

  default_categories = {pkgs, ...} @ misc: {
    C = true;
    bash = true;
    debug = false;
    docker = true;
    general = true;
    go = true;
    lua = true;
    neonixdev = true;
    nix = true;
    nu = true;
    other = true;
    python = true;
    racket = true;
    rust = false;
    serde = true;
    sql = true;
    tex = true;
    theme = true;
    treesitter = true;
    web = true;
  };

  default_extra = {pkgs, ...} @ misc: {
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
        aliases = ["vi" "nvim"];
      };
    categories = default_categories args // {};
    extra = default_extra args // {};
  };

  nvim-testing = args: {
    settings =
      default_settings args
      // {
        wrapRc = false;
      };
    categories = default_categories args // {};
    extra = default_extra args // {};
  };

  nvim-small = args: {
    settings = default_settings args // {};
    categories = {
      general = true;
      theme = true;
    };
    extra = default_extra args // {};
  };

  nvim-minimal = args: {
    settings = default_settings args // {};
    categories = {
      general = {
        core = true;
        cmp = true;
        bash = false;
        treesitter = false;
      };
      theme = true;
    };
    extra = default_extra args // {};
  };
}
