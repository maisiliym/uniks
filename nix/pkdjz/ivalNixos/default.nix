inputs@{ src, lib, pkgs, system }:

argz@
{ nixpkgs ? src
, pkgs ? inputs.pkgs
, modules ? [ ]
, moduleArgs ? { }
, iuzQemuVmModule ? false
, iuzIsoModule ? false
}:
let
  inherit (lib) evalModules optional;

  nixosNixpkgsConfig = {
    nixpkgs = {
      inherit pkgs system;
      # allowUnfree = true;
    };
  };

  specialArgs = {
    modulesPath = toString (nixpkgs + /nixos/modules);
  };

  baseModules = import (nixpkgs + /nixos/modules/module-list.nix);
  qemuVmModule = import (nixpkgs + /nixos/modules/virtualisation/qemu-vm.nix);
  isoImageModule = import (nixpkgs + /nixos/modules/installer/cd-dvd/iso-image.nix);

  nixOSRev = src.shortRev;

  moduleArgsModule = {
    _module.args = {
      inherit lib pkgs baseModules nixOSRev;
    }
    // moduleArgs;
  };

in
evalModules {
  inherit specialArgs;
  modules = argz.modules ++ baseModules
    ++ [ moduleArgsModule nixosNixpkgsConfig ]
    ++ (optional iuzQemuVmModule qemuVmModule)
    ++ (optional iuzIsoModule isoImageModule);
}
