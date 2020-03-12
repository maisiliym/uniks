hob:

let
  pkdjz = {
    bildNvimPlogin = {
      lamdy = import ./bildNvimPlogin;
      modz = [ "pkgs" "pkdjz" ];
      self = null;
    };

    crate2nix = {
      lamdy = import ./crate2nix;
      modz = [ "pkdjz" ];
    };

    deryveicyn = {
      lamdy = import ./deryveicyn;
      modz = [ "pkdjz" ];
      self = null;
    };

    dino = {
      lamdy = import ./dino;
      modz = [ "pkgs" ];
    };

    dunst = {
      lamdy = import ./dunst;
      modz = [ "pkgs" ];
    };

    fzf = {
      lamdy = import ./fzf;
      modz = [ "pkgs" ];
    };

    guix = {
      lamdy = import ./guix;
      modz = [ "lib" "pkgs" "hob" ];
    };

    home-manager = {
      lamdy = import ./home-manager;
      modz = [ "lib" "pkgs" "hob" ];
    };

    ivalNixos = {
      lamdy = import ./ivalNixos;
      modz = [ "lib" "pkgsSet" ];
      self = hob.nixpkgs.mein;
    };

    kreitOvyraidz = {
      lamdy = import ./kreitOvyraidz;
      modz = [ "pkgs" "lib" ];
      self = null;
    };

    kynvyrt = {
      lamdy = import ./kynvyrt;
      modz = [ "pkgs" "uyrld" ];
      self = null;
    };

    lib = {
      lamdy = import ./lib;
      modz = [ ];
      self = hob.nixpkgs.mein;
    };

    librem5-flash-image = {
      lamdy = import ./librem5/flashImage.nix;
      modz = [ "pkgs" ];
    };

    lowdown = {
      lamdy = import ./lowdown;
      modz = [ "pkgs" ];
    };

    LuaFormatter = {
      lamdy = import ./LuaFormatter;
      modz = [ "pkgs" ];
    };

    lua-language-server = {
      lamdy = import ./lua-language-server;
      modz = [ "pkgs" ];
    };

    mach-nix = { lamdy = import ./mach-nix; };

    meikPkgs = {
      lamdy = import ./meikPkgs;
      modz = [ "lib" ];
      self = hob.nixpkgs.mein;
    };

    meikImaks = {
      lamdy = import ./meikImaks;
      modz = [ "pkdjz" "hob" ];
      self = hob.emacs-overlay.mein;
    };

    mfgtools = {
      lamdy = import ./mfgtools;
      modz = [ "pkgs" ];
    };

    mkCargoNix = {
      lamdy = import ./mkCargoNix;
      modz = [ "pkgs" "lib" "pkdjz" ];
      self = null;
    };

    mozPkgs = {
      lamdy = import ./mozPkgs;
      modz = [ "pkdjz" ];
      self = hob.nixpkgs-mozilla.mein;
    };

    naersk = {
      lamdy = import ./naersk;
      modz = [ "pkgs" ];
    };

    neovim = {
      lamdy = import ./neovim;
      modz = [ "pkgs" ];
    };

    nvimLuaPloginz = {
      lamdy = import ./nvimPloginz/lua.nix;
      modz = [ "hob" "pkdjz" ];
      self = null;
    };

    nvimPloginz = {
      lamdy = import ./nvimPloginz;
      modz = [ "hob" "pkdjz" ];
      self = null;
    };

    nerd-fonts = {
      lamdy = import ./nerd-fonts;
      modz = [ "pkgs" ];
      self = null;
    };

    nightlyRust = {
      lamdy = import ./nightlyRust;
      modz = [ "pkdjz" ];
      self = null;
    };

    nix = { lamdy = import ./nix; };

    nixpkgs-fmt = {
      lamdy = import ./nixpkgs-fmt;
      modz = [ "pkdjz" ];
    };

    nix-dev = {
      lamdy = import ./nix;
      modz = [ "pkgs" "pkdjz" ];
      self = hob.nix.maisiliym.dev;
    };

    pkgs = {
      lamdy = import ./pkgs;
      modz = [ "pkdjz" ];
    };

    pkgsNvimPloginz = {
      lamdy = import ./pkgsNvimPloginz;
      modz = [ "pkgsSet" "lib" "pkdjz" ];
      self = hob.nixpkgs.mein;
    };

    ql2nix = {
      lamdy = import ./ql2nix;
      modz = [ "pkgsSet" ];
    };

    rnix-lsp = {
      lamdy = import ./rnix-lsp;
      modz = [ "pkdjz" ];
    };

    rust-analyzer = {
      lamdy = import ./rust-analyzer;
      modz = [ "pkgs" "pkdjz" ];
    };

    sbcl = {
      lamdy = import ./sbcl/static.nix;
      modz = [ "pkgsSet" "pkgsStatic" ];
    };

    shen-bootstrap = {
      lamdy = import ./shen/bootstrap.nix;
      modz = [ "pkgs" ];
      self = hob.shen.mein;
    };

    shen-ecl-bootstrap = {
      lamdy = import ./shen/ecl.nix;
      modz = [ "pkgs" ];
      self = null;
    };

    shenPrelude = {
      lamdy = import ./shen/prelude.nix;
      modz = [ "pkgs" ];
    };

    slynkPackages = {
      lamdy = import ./slynkPackages;
      modz = [ "pkgs" ];
      self = null;
    };

    tree-sitter = {
      lamdy = import ./tree-sitter;
      modz = [ "pkgs" "pkdjz" ];
    };

    tree-sitter-parsers = {
      lamdy = import ./tree-sitter/parsers.nix;
      modz = [ "pkgs" "pkdjz" "hob" ];
      self = null;
    };

    uniks = {
      lamdy = import ./uniks;
      modz = [ "pkgs" "pkdjz" ];
    };

    vimPloginz = {
      lamdy = import ./vimPloginz;
      modz = [ "pkgs" "pkdjz" "hob" ];
      self = null;
    };
  };

  aliases = {
    shen = pkdjz.shen-ecl-bootstrap;
  };

in
pkdjz // aliases 
