{ src, system }:

{
  package = src.packages.${system}.mach-nix;
  lib = src.lib.${system};
}
