{ self, mkCargoNix, }:
let
  crates = mkCargoNix {
    nightly = true;
    cargoNix = import (self + /Cargo.nix);
    crateOverrides = { };
  };

in
crates.workspaceMembers.nixpkgs-fmt.build
