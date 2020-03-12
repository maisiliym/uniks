{ config, lib, metastrizSpiciz, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) enum str attrsOf submodule nullOr bool int
    listOf attrs;

  inherit (metastrizSpiciz) metastriNeimz astriSpiciz
    magnytiud sistymz komynKrimynOptions mycinSpici IoOptions;

  astriOptions = {
    neim = mkOption {
      type = str;
    };

    spici = mkOption {
      type = enum astriSpiciz;
      default = "sentyr";
    };

    trost = mkOption {
      type = enum magnytiud;
    };

    uniksNeim = mkOption {
      type = str;
    };

    sistym = mkOption {
      type = enum sistymz;
    };

    nbOfBildKorz = mkOption {
      type = int;
      default = 1;
    };

    saiz = mkOption {
      type = enum magnytiud;
    };

    mycin = mkOption {
      type = mycinSpici;
    };

    yggPriKriom = mkOption {
      type = nullOr str;
      default = null;
    };

    yggAddress = mkOption {
      type = nullOr str;
      default = null;
    };

    yggSubnet = mkOption {
      type = nullOr str;
      default = null;
    };

    eseseitc = mkOption {
      type = nullOr str;
      default = null;
    };

    niksPriKriom = mkOption {
      type = nullOr str;
      default = null;
    };

    spinyrz = mkOption {
      type = attrs;
      default = { };
    };
  };

  metastraSubmodule = {
    options = {
      neim = mkOption {
        type = enum metastriNeimz;
      };

      spinyrz = mkOption {
        type = attrs;
        default = { };
      };
    };
  };

  astraOptions = astriOptions // {
    io = mkOption {
      type = submodule { options = IoOptions; };
      default = { };
    };
  };

  krimynSubmodule = {
    options = komynKrimynOptions // {
      neim = mkOption {
        type = str;
      };

      trost = mkOption {
        type = enum magnytiud;
      };

      spinyrz = mkOption {
        type = attrs;
        default = { };
      };
    };
  };

  hyraizynOptions = {
    options = {
      metastra = mkOption {
        type = submodule metastraSubmodule;
      };

      astra = mkOption {
        type = submodule { options = astraOptions; };
      };

      exAstriz = mkOption {
        type = attrsOf (submodule { options = astriOptions; });
      };

      krimynz = mkOption {
        type = attrsOf (submodule krimynSubmodule);
      };

      spinyrz = mkOption {
        type = attrs;
        default = { };
      };
    };
  };

in
{
  options = {
    hyraizyn = mkOption {
      type = submodule hyraizynOptions;
    };

    astraNeim = mkOption {
      type = str;
    };

    metastraNeim = mkOption {
      type = str;
    };

  };

}
