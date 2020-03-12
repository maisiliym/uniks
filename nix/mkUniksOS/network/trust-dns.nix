{ config, lib, pkgs, kor, hyraizyn, uyrld, ... }:

let
  inherit (builtins) map;
  inherit (lib) mkOverride;
  inherit (hyraizyn.astra) uniksNeim;
  inherit (uyrld.pkdjz) trust-dns;

  trustDnsEksek = "${trust-dns}/bin/named";

  astraZone = {
    zone = uniksNeim;
    zone_type = "Master";
    file = "example.com.zone";
    allow_update = false;
    allow_axfr = false;
    enable_dnssec = false;
  };

  forwardCloudflare = {
    zone = ".";
    zone_type = "Forward";
    stores = {
      type = "forward";
      name_servers = [
        { socket_addr = "1.1.1.1:853"; protocol = "Udp"; }
        { socket_addr = "1.1.1.1:853"; protocol = "Tcp"; }
        { socket_addr = "1.0.0.1:853"; protocol = "Udp"; }
        { socket_addr = "1.0.0.1:853"; protocol = "Tcp"; }
        { socket_addr = "2606:4700:4700::1111:853"; protocol = "Tcp"; }
        { socket_addr = "2606:4700:4700::1001:853"; protocol = "Tcp"; }
      ];
    };
  };

  zones = [
    forwardCloudflare
  ];

  config = {
    # listen_addrs_ipv4 = [ "0.0.0.0" ];
    listen_addrs_ipv6 = [ "::1" ];
    directory = "";
    inherit zones;
  };

  configFile = toFormatFile
    {
      neim = "trust-dns-config";
      valiu = config;
      preti = true;
    };

in
{
  systemd.services.trust-dns = {
    description = "Trust-DNS authoritative server";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${trustDnsEksek} --config=${configFile}";
      DynamicUser = true;
      ConfigurationDirectory = "trust-dns";
      StateDirectory = "trust-dns";
      Restart = "on-abnormal";
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
      NoNewPrivileges = true;
      PrivateDevices = true;
    };
  };

}
