{ kor, pkgs, ... }:
let
  inherit (kor) eksportJSON;

  config = { };

  configFile = eksportJSON "element-config.json" config;

in
{
  systemd.services.nginx-element = {
    description = "Element-web matrix client";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    preStart = '' '';

    restartTriggers = [ configFile ];

    serviceConfig = {
      ExecStart = "${pkgs.nginx}/bin/element -d -c ${configFile}";
      ExecReload = "+/run/current-system/sw/bin/kill -HUP $MAINPID";

      NotifyAccess = "main";
      Type = "notify";
      Restart = "on-abnormal";

      DynamicUser = true;
      RuntimeDirectory = "element";
      ConfigurationDirectory = "element";
      StateDirectory = "element";

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
      SystemCallFilter = [ ];
      RestrictNamespaces = true;
      LockPersonality = true;
      RestrictSUIDSGID = true;
    };
  };
}
