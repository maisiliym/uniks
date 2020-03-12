argz@
{ lib
, home-manager
, pkgs
, kor
, kriozon
, krimyn
, profile
, uyrld
, hob
}:
let
  inherit (kor) optional;
  inherit (argz.uyrld) pkdjz;
  inherit (krimyn) stail;
  inherit (krimyn.spinyrz) saizAtList;
  inherit (home-manager.lib) homeManagerConfiguration;

  mkHomeManagerModules = import (home-manager + /modules/modules.nix);
  extendedLib = import (home-manager + /modules/lib/stdlib-extended.nix) lib;
  inherit (extendedLib) evalModules;

  homeManagerModules = mkHomeManagerModules {
    inherit pkgs;
    lib = extendedLib;
    useNixpkgsModule = false;
  };

  beisModule = import ./beisModule.nix;

  stailModule =
    if (stail == "emacs")
    then (import ./emacs) else (import ./neovim);

  homModules = [ beisModule ]
    ++ (optional saizAtList.min (import ./min))
    ++ (optional saizAtList.med (import ./med))
    ++ (optional saizAtList.max (import ./max));

  argzModule = {
    home.stateVersion = lib.trivial.release;
    _module.args = {
      inherit pkgs kor pkdjz uyrld hob
        krimyn kriozon profile;
      hyraizyn = kriozon;
    };
  };

  modules = homModules ++ homeManagerModules
    ++ [ argzModule stailModule ];

  ival = evalModules {
    inherit modules;
  };

in
ival.config.home.activationPackage
