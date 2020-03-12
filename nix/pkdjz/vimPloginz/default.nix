{ hob, vimUtils, fzf }:
let
  inherit (builtins) mapAttrs;
  inherit (vimUtils) buildVimPluginFrom2Nix;

  implaidSpoks = (import ./../nvimPloginz/spoksFromHob.nix) hob;

  eksplisitSpoks = { };

  mkImplaidSpoks = neim: spok: spok.mein;

  spoks = eksplisitSpoks
    // (mapAttrs (n: s: s.mein) implaidSpoks);

  fzf-vim-core = buildVimPluginFrom2Nix {
    pname = "fzf";
    version = fzf.version;
    src = fzf.src;
  };

  ovyraidzIndeks = {
    fzf-vim = { dependencies = [ fzf-vim-core ]; };
  };

  forkIndeks = { };

  bildVimPlogin = { neim, self, ovyraidz }:
    let
    in
    buildVimPluginFrom2Nix ({
      pname = neim;
      version = self.shortRev;
      src = self;
    } // ovyraidz);

  mkSpok = neim: self:
    let
      ovyraidz = ovyraidzIndeks.${neim} or { };
    in
    bildVimPlogin { inherit neim self ovyraidz; };

  ryzylt = mapAttrs mkSpok spoks;

in
ryzylt
