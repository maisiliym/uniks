{ lib, ... }:
let
  inherit (lib) mkOverride;

in
{
  imports = [
    # ./trust-dns.nix
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
      neksis = {
        description = "neksis network online";
        after = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
      };
    };

  };
}
