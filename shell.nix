let
  flakeCompat = import ./nix/flake-compat.nix;

in
flakeCompat.shellNix
