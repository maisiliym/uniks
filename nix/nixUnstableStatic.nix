{ src, pkgsStaticNixUnstable }:
pkgsStaticNixUnstable.overrideAttrs (attrs: {
  inherit src;

  # fetchFromGitHub {
  #   owner = "nixos";
  #   repo = "nix";
  #   # https://github.com/NixOS/nix/issues/5306
  #   rev = "af94b54db3a2be100731a215cb5e95f306471731";
  #   sha256 = "00y4q29j0m6yrgxa44jy2hsql2sqg1nrsl9ddm6r2q5vm51i5qhz";
  # };

  hardeningEnable = [ "pie" ];
  hardeningDisable = [ "pie" ];
})
