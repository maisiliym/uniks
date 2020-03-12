{ self, runCommand, mkCargoNix, makeWrapper }:
let
  unwrapped = (mkCargoNix {
    nightly = true;
    cargoNix = import (self + /Cargo.nix);
    crateOverrides = {
      rust-analyzer = attrs: {
        REV = self.shortRev;
      };
    };
  }).workspaceMembers.rust-analyzer.build;

in
runCommand "rust-analyzer-wrapped"
{ nativeBuildInputs = [ makeWrapper ]; }
  ''
    mkdir -p $out/bin
    makeWrapper ${unwrapped}/bin/rust-analyzer \
    $out/bin/rust-analyzer \
    --set-default RUST_SRC_PATH "/git/github.com/rust-lang/rust/library/"
  ''
