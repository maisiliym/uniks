{ lib, config, ... }:
let
  inherit (builtins) mapAttrs attrNames listToAttrs;
  inherit (lib) mkOption nameValuePair;
  inherit (lib.types) enum str attrsOf submodule nullOr attrs listOf;
  inherit (config.spiciz) magnytiud metastriNeimz astriSpiciz
    komynKrimynOptions mycinSpici IoOptions;

  AstriPriKriomSpici = submodule {
    options = {
      eseseitc = mkOption {
        type = nullOr str;
        default = null;
      };

      yggdrasil = {
        priKriom = mkOption {
          type = nullOr str;
          default = null;
        };

        address = mkOption {
          type = nullOr str;
          default = null;
        };

        subnet = mkOption {
          type = nullOr str;
          default = null;
        };
      };

      niksPriKriom = mkOption {
        type = nullOr str;
        default = null;
      };
    };
  };

  astriSubmodule = {
    options = {
      spici = mkOption {
        type = enum astriSpiciz;
        default = "sentyr";
      };

      saiz = mkOption {
        type = enum magnytiud;
        default = 0;
      };

      trost = mkOption {
        type = enum magnytiud;
        default = 1;
      };

      mycin = mkOption {
        type = mycinSpici;
      };

      io = mkOption {
        type = submodule { options = IoOptions; };
        default = { };
      };

      priKriomz = mkOption {
        type = AstriPriKriomSpici;
        default = { };
      };
    };
  };


  defaultTrost = 1;

  mkDefaultTrostFromNeimz = neimz: listToAttrs
    (map (n: nameValuePair n defaultTrost))
    neimz;

  trostSubmodule = {
    options = {
      metastra = mkOption {
        type = enum magnytiud;
        default = 1;
      };

      metastriz = mkOption {
        type = attrsOf (enum magnytiud);
      };

      astriz = mkOption {
        type = attrsOf (enum magnytiud);
      };

      krimynz = mkOption {
        type = attrsOf (enum magnytiud);
      };
    };
  };

  domeinSubmodule = {
    options = {
      spici = mkOption {
        type = enum [ "cloudflare" ];
        default = "cloudflare";
      };
    };
  };

  krimynSubmodule = {
    options = komynKrimynOptions;
  };

  metastriSubmodule = {
    options = {
      astriz = mkOption {
        type = attrsOf (submodule astriSubmodule);
        default = {
          priKriomz = { };
        };
      };

      krimynz = mkOption {
        type = attrsOf (submodule krimynSubmodule);
      };

      domeinz = mkOption {
        type = attrsOf (submodule domeinSubmodule);
        default = { };
      };

      trost = mkOption {
        type = submodule trostSubmodule;
      };
    };
  };

in
{
  options = {
    PriMetastriz = mkOption {
      type = attrsOf (submodule metastriSubmodule);
    };

    Metastriz = mkOption {
      type = attrsOf (submodule metastriSubmodule);
    };
  };

  /* Normalize Metastriz here */
  config.Metastriz = config.PriMetastriz;
}
