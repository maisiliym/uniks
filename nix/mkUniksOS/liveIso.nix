{ pkgs, lib, hyraizyn, config, kor, nixOSRev, ... }:
let
  inherit (lib) mkOverride;

in
{
  boot = {
    supportedFilesystems = mkOverride 10 [ "btrfs" "vfat" "xfs" "ntfs" ];
  };

  isoImage = {
    isoBaseName = "uniksos";
    volumeID = "uniksos-${nixOSRev}-${pkgs.stdenv.hostPlatform.uname.processor}";

    makeUsbBootable = true;
    makeEfiBootable = true;
  };

}
