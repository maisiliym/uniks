{ self, mkCargoNix, }:
let
  crates = mkCargoNix {
    nightly = true;
    cargoNix = import (self + /Cargo.nix);
  };

in
crates.workspaceMembers.rnix-lsp.build
