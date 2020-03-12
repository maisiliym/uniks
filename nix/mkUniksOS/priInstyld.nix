{ kor, hyraizyn, ... }:
let
  inherit (builtins) mapAttrs attrNames filter;
  inherit (kor) optionals mkIf optional;

  inherit (hyraizyn.astra.io) disks swapDevices butlodyr;

in
{
  boot = {
    supportedFilesystems = [ "xfs" ];

    loader = {
      grub.enable = butlodyr == "mbr";
      systemd-boot.enable = butlodyr == "uefi";
      efi.canTouchEfiVariables = butlodyr == "uefi";
      generic-extlinux-compatible.enable = butlodyr == "uboot";
    };

  };

  fileSystems = disks;
  inherit swapDevices;

}
