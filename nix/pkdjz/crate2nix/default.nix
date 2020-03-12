{ self, mkCargoNix, }:
let
  cargoNixRyzylt = mkCargoNix {
    nightly = true;
    cargoNix = import (self + /crate2nix/Cargo.nix);
    crateOverrides = { };
  };

in
cargoNixRyzylt.workspaceMembers.crate2nix.build
