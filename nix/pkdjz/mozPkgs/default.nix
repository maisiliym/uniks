{ self, meikPkgs }:

meikPkgs {
  overlays = [ (import (self + /rust-overlay.nix)) ];
}
