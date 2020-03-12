{ lib, ... }:
let
  inherit (lib) mkOverride;

in
{
  imports = [
    ./unbound.nix
    ./yggdrasil.nix
  ];

  networking = {
    nameservers = [ "::1" ];
  };

  services = {
    nscd.enable = false;
  };

  system.nssModules = mkOverride 0 [ ];

  systemd = {
    targets = {
      neksys = {
        description = "neksys network online";
        after = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
      };
    };

  };
}
