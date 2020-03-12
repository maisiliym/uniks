{ config, lib, pkgs, kor, hyraizyn, ... }:

let
  inherit (builtins) map concatStringsSep;
  inherit (kor) mapAttrsToList concatMapStringsSep;
  inherit (hyraizyn.astra) uniksNeim;

  stateDir = "/var/lib/private/unbound";
  runtimeDir = "/run/private/unbound";
  rootTrustAnchorFile = "${stateDir}/rootAnchor.key";

  listenIPs = [ "::1" ];
  allowedIPs = [ "::1" ];

  interfaces = concatMapStringsSep "\n  " (x: "interface: ${x}") listenIPs;

  access = concatMapStringsSep "\n  " (x: "access-control: ${x} allow") allowedIPs;

  TLSDNServers = {
    "2606:4700:4700::1111" = "cloudflare-dns.com";
    "1.1.1.1" = "cloudflare-dns.com";
    "2606:4700:4700::1001" = "cloudflare-dns.com";
    "1.0.0.1" = "cloudflare-dns.com";
    "2620:fe::fe" = "dns.quad9.net";
    "9.9.9.9" = "dns.quad9.net";
    "2620:fe::9" = "dns.quad9.net";
    "149.112.112.112" = "dns.quad9.net";
  };

  forwardServerStrings = mapAttrsToList
    (ip: domain: "  forward-addr: ${ip}@853#${domain}")
    TLSDNServers;

  forwardOverTLS = ''
    forward-zone:
      forward-tls-upstream: yes
      name: .
  '' +
  concatStringsSep "\n" forwardServerStrings;

  disabledOpts = ''
    username: ""
    chroot: ""
    pidfile: ""
  '';

  configFile = pkgs.writeText "unbound.conf" ''
    server:
      do-not-query-localhost: no
      tls-cert-bundle: /etc/ssl/certs/ca-certificates.crt
      auto-trust-anchor-file: ${rootTrustAnchorFile}
      ${disabledOpts}
      ${interfaces}
      ${access}

    ${forwardOverTLS}
  '';

in
{
  systemd.services.unbound = {
    description = "Unbound recursive Domain Name Server";
    after = [ "network.target" ];
    before = [ "nss-lookup.target" ];
    wantedBy = [ "multi-user.target" "nss-lookup.target" ];

    preStart = ''
      ${pkgs.unbound}/bin/unbound-anchor -4 -a ${rootTrustAnchorFile}
    '';

    restartTriggers = [ configFile ];
    serviceConfig = {
      ExecStart = "${pkgs.unbound}/bin/unbound -d -c ${configFile}";
      ExecReload = "+/run/current-system/sw/bin/kill -HUP $MAINPID";

      NotifyAccess = "main";
      Type = "notify";
      Restart = "on-abnormal";

      DynamicUser = true;
      RuntimeDirectory = "unbound";
      ConfigurationDirectory = "unbound";
      StateDirectory = "unbound";

      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];

      # TODO - find redundancy
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      ProtectControlGroups = true;
      ProtectKernelModules = true;
      ProtectSystem = "strict";
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_NETLINK" "AF_UNIX" ];
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "~@clock"
        "@cpu-emulation"
        "@debug"
        "@keyring"
        "@module"
        "mount"
        "@obsolete"
        "@resources"
      ];
      RestrictNamespaces = true;
      LockPersonality = true;
      RestrictSUIDSGID = true;
    };
  };

}
