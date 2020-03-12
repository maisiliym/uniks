{ kor, pkgs, hyraizyn, konstynts, ... }:
let
  inherit (builtins) mapAttrs attrNames filter;
  inherit (kor) mkIf;
  inherit (hyraizyn.astra.spinyrz) izYggKriodaizd;
  inherit (konstynts) fileSystem;
  inherit (konstynts.fileSystem.yggdrasil) priKriodJson
    subDirName datomJson interfaceName combinedConfigJson;
  inherit (konstynts.network.yggdrasil) ports;

  yggExec = "${pkgs.yggdrasil}/bin/yggdrasil";
  yggCtlExec = "${pkgs.yggdrasil}/bin/yggdrasilctl";
  jqEksek = "${pkgs.jq}/bin/jq";

  yggKriodFilterSocket = fileSystem.systemd.runtimeDirectory + "/yggKriodFilter";

  mkConfigFile = conf: pkgs.writeTextFile {
    name = "yggdrasilConf.json";
    text = builtins.toJSON conf;
  };

  yggdrasilConfig = {
    LinkLocalTCPPort = ports.linkLocalTCP;
    IfName = "yggTun";
  };

  configFile = mkConfigFile yggdrasilConfig;

in
{
  networking.firewall = {
    allowedUDPPorts = [ ports.multicast ];
    allowedTCPPorts = [ ports.linkLocalTCP ];
    trustedInterfaces = [ interfaceName ];
  };

  systemd = {
    services = {
      kriodaizYggdrasil = mkIf (!izYggKriodaizd) {
        description = "Generate Yggdrasil kriod";
        before = [ "yggKriodFilter.socket" ];
        serviceConfig = {
          ExecStart = "${yggExec} -genconf -json";
          StandardOutput = "file:${yggKriodFilterSocket}";
        };
      };

      yggKriodFilter = mkIf (!izYggKriodaizd) {
        description = "Filter generated yggdrasil kriod";
        before = [ "kombainYggKonfig.service" ];
        serviceConfig = {
          ExecStart = "${jqEksek} '{ EncryptionPublicKey, EncryptionPrivateKey, SigningPublicKey, SigningPrivateKey }'";
          Sockets = "yggKriodFilter.socket";
          StandardInput = "socket";
          # StandardOutput = "file:${priKriodJson}";
          StandardOutput = "journal";
        };
      };

      kombainYggKonfig = {
        description = "Filter generated yggdrasil kriod";
        requiredBy = [ "neksys-yggdrasil.service" ];
        before = [ "neksys-yggdrasil.service" ];
        serviceConfig = {
          ExecStart = "${jqEksek} --slurp add ${priKriodJson} ${configFile}";
          StandardOutput = "file:${combinedConfigJson}";
        };
      };

      neksys-yggdrasil = {
        description = "neksys Yggdrasil";
        wantedBy = [ "neksys-online.target" ];
        serviceConfig = {
          ExecStart = "${yggExec} -useconffile ${combinedConfigJson}";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          Restart = "always";
          StateDirectory = subDirName;
          RuntimeDirectory = subDirName;
          RuntimeDirectoryMode = "0755";
          AmbientCapabilities = "CAP_NET_ADMIN";
          CapabilityBoundingSet = "CAP_NET_ADMIN";
          DynamicUser = true;
          MemoryDenyWriteExecute = true;
          ProtectControlGroups = true;
          ProtectHome = "tmpfs";
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = "~@clock @cpu-emulation @debug @keyring @module @mount @obsolete @raw-io @resources";
        };
      };

      ekstraktYggDatom = mkIf (!izYggKriodaizd) {
        description = "Extract generated yggdrasil datom";
        serviceConfig = {
          ExecStart = " ${yggCtlExec} -json -v getself";
          StandardOutput = "file:${datomJson}";
        };
      };

    };

    sockets = {
      yggKriodFilter = mkIf (!izYggKriodaizd) {
        description = "Capture pre-filtered yggdrasil kriod";
        socketConfig = {
          ListenFIFO = yggKriodFilterSocket;
          SocketMode = "0600";
        };
      };
    };

  };
}
