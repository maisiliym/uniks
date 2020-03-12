{ self, kor, lib, pkgs, bildNvimPlogin }:
let
  inherit (kor) mkLamdy;

  ovyridynPkgs = pkgs
    // { buildVimPluginFrom2Nix = bildNvimPlogin; };

  overridesLamdy = import (self + /pkgs/misc/vim-plugins/overrides.nix);

  overrides = mkLamdy {
    lamdy = overridesLamdy;
    klozyr = ovyridynPkgs;
  };

  lamdy = import (self + /pkgs/misc/vim-plugins/generated.nix);

  klozyr = ovyridynPkgs //
    { inherit overrides; };

  plugins = mkLamdy {
    inherit lamdy klozyr;
  };

  brokenPlugins = [ "minimap-vim" ];

in
removeAttrs plugins brokenPlugins
