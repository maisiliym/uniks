{ kor, pkgs, hyraizyn, uyrld, konstynts, ... }:
let
  inherit (builtins) mapAttrs attrNames filter;
  inherit (kor) optionals mkIf optional eksportJSON;

  inherit (hyraizyn.metastra.spinyrz) trostydBildPriKriomz;
  inherit (hyraizyn) astra;
  inherit (hyraizyn.astra.spinyrz) exAstrizEseseitcPriKriomz
    bildyrKonfigz kacURLz dispatcyrzEseseitcKiz
    izBildyr izNiksKac izDispatcyr izKriodaizd;

  inherit (konstynts.fileSystem.niks) priKriod;
  inherit (konstynts.network.niks) serve;

  jsonHyraizynFail = eksportJSON "hyraizyn.json" hyraizyn;

  niksRegistry = {
    flakes = [{
      from = {
        type = "indirect";
        id = "uniks";
      };
      to = {
        type = "github";
        owner = "maisiliym";
        repo = "uniks";
      };
    }];
    version = 2;
  };

  redjistri = eksportJSON "niksRegistry.json"
    niksRegistry;

in
{
  environment.etc."hyraizyn.json" = {
    source = jsonHyraizynFail;
    mode = "0600";
  };

  networking = {
    hostName = astra.neim;
    dhcpcd.extraConfig = "noipv4ll";
  };

  nix = {
    package = uyrld.pkdjz.nix;

    trustedUsers = [ "root" "@nixdev" ];

    allowedUsers = [ "@users" "nix-serve" ]
      ++ optional izBildyr "niksBildyr";

    buildCores = astra.nbOfBildKorz;

    # Lowest priorities
    daemonNiceLevel = 19;
    daemonIONiceLevel = 7;

    sandboxPaths = [
      # "/links"  # TODO
    ];

    binaryCachePublicKeys = trostydBildPriKriomz;
    binaryCaches = kacURLz;
    trustedBinaryCaches = kacURLz;

    autoOptimiseStore = true;

    extraOptions = ''
      flake-registry = ${redjistri}
      experimental-features = nix-command flakes ca-references recursive-nix
      secret-key-files = ${priKriod}
    '';

    sshServe = {
      enable = izNiksKac;
      keys = exAstrizEseseitcPriKriomz;
      protocol = "ssh";
    };

    distributedBuilds = izDispatcyr;
    buildMachines = optionals izDispatcyr bildyrKonfigz;

  };

  users = {
    groups = {
      nixdev = { };
      niksBildyr = { };
    };
    users = mkIf izBildyr {
      niksBildyr = {
        isNormalUser = true;
        useDefaultShell = true;
        openssh.authorizedKeys.keys = dispatcyrzEseseitcKiz;
      };
    };

  };

  services = {
    nix-serve = {
      enable = izNiksKac;
      bindAddress = "127.0.0.1";
      port = serve.ports.internal;
      secretKeyFile = priKriod;
    };

    nginx = mkIf (izNiksKac && izKriodaizd) {
      enable = true;
      virtualHosts = {
        "[${astra.yggAddress}]:${toString serve.ports.external}" = {
          listen = [{ addr = "[${astra.yggAddress}]"; port = serve.ports.external; }];
          locations."/".proxyPass = "http://127.0.0.1:${toString serve.ports.internal}";
        };
      };
    };

  };

}
