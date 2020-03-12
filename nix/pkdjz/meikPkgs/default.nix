inputs@{ src, lib, system }:

meikArgz@
{ src ? inputs.src
, lib ? inputs.lib
, overlays ? [ ]
, config ? { allowUnfree = true; }
, localSystem ? { system = inputs.system; }
, crossSystem ? localSystem
}:
let
  inherit (builtins) intersectAttrs;
  inherit (lib) optional;

  clumsyLinuxStdenvStages =
    { lib
    , localSystem
    , crossSystem
    , config
    , overlays
    , ...
    }@args:
    import (src + /pkgs/stdenv/linux) args;

  clumsyCrossLinuxStdenvStages =
    { lib
    , localSystem
    , crossSystem
    , config
    , overlays
    , crossOverlays ? [ ]
    , ...
    }:
    let
      inherit (lib) init last;

      bootStages = clumsyLinuxStdenvStages {
        inherit lib localSystem overlays;
        crossSystem = localSystem;
        crossOverlays = [ ];
        config = removeAttrs config [ "replaceStdenv" ];
      };

    in
    init bootStages ++ [
      # Regular native packages
      (somePrevStage: last bootStages somePrevStage // {
        # It's OK to change the built-time dependencies
        allowCustomOverrides = true;
      })

      # Build tool Packages
      (vanillaPackages: {
        inherit config overlays;
        selfBuild = false;
        stdenv =
          assert vanillaPackages.stdenv.buildPlatform == localSystem;
          assert vanillaPackages.stdenv.hostPlatform == localSystem;
          assert vanillaPackages.stdenv.targetPlatform == localSystem;
          vanillaPackages.stdenv.override { targetPlatform = crossSystem; };
        # It's OK to change the built-time dependencies
        allowCustomOverrides = true;
      })

      # Run Packages
      (buildPackages: {
        inherit config;
        overlays = overlays ++ crossOverlays
        ++ (if crossSystem.isWasm then [ (import (src + /pkgs/top-level/static.nix)) ] else [ ]);
        selfBuild = false;
        stdenv = buildPackages.stdenv.override (old: rec {
          buildPlatform = localSystem;
          hostPlatform = crossSystem;
          targetPlatform = crossSystem;

          # Prior overrides are surely not valid as packages built with this run on
          # a different platform, and so are disabled.
          overrides = _: _: { };
          extraBuildInputs = [ ]; # Old ones run on wrong platform
          allowedRequisites = null;

          cc =
            if crossSystem.useAndroidPrebuilt or false
            then buildPackages."androidndkPkgs_${crossSystem.ndkVer}".clang
            else if targetPlatform.isGhcjs
            then null
            else if crossSystem.useLLVM or false
            then buildPackages.llvmPackages_8.lldClang
            else buildPackages.gcc;

          extraNativeBuildInputs = old.extraNativeBuildInputs
          ++ optional
            (let f = p: !p.isx86 || p.libc == "musl" || p.libc == "wasilibc" || p.isiOS; in f hostPlatform && !(f buildPlatform))
            buildPackages.updateAutotoolsGnuConfigScriptsHook;
        });
      })

    ];

  determineStdenvStages =
    { lib
    , localSystem
    , crossSystem
    , config
    , overlays
    , crossOverlays ? [ ]
    }@args:
    let
      inherit clumsyCrossLinuxStdenvStages clumsyLinuxStdenvStages;

      noCross = (crossSystem == localSystem);

      stdenvStagesFn =
        if noCross then clumsyLinuxStdenvStages
        else clumsyCrossLinuxStdenvStages;

    in
    stdenvStagesFn args;

  topLevelFn = let inherit determineStdenvStages; in
    { localSystem
    , crossSystem ? localSystem
    , config ? { }
    , overlays ? [ ]
    , crossOverlays ? [ ]
    , stdenvStages ? determineStdenvStages
    }@args:

    let
      config0 = config;
      crossSystem0 = crossSystem;

    in
    let
      inherit (lib) systems evalModules showWarnings;

      localSystem = systems.elaborate args.localSystem;

      crossSystem =
        if crossSystem0 == null || crossSystem0 == args.localSystem
        then localSystem
        else lib.systems.elaborate crossSystem0;

      config1 =
        if builtins.isFunction config0
        then config0 { inherit pkgs; }
        else config0;

      configEval = evalModules {
        modules = [
          (src + /pkgs/top-level/config.nix)
          ({ options, ... }: {
            _file = "nixpkgs.config";
            config = intersectAttrs options config1;
          })
        ];
      };

      config = showWarnings configEval.config.warnings
        (config1 // removeAttrs configEval.config [ "_module" ]);

      nixpkgsFun = newArgs: topLevelFn (args // newArgs);

      allPackages = newArgs:
        import (src + /pkgs/top-level/stage.nix) ({ inherit lib nixpkgsFun; } // newArgs);

      boot = import (src + /pkgs/stdenv/booter.nix) { inherit lib allPackages; };

      stages = stdenvStages {
        inherit lib localSystem crossSystem config overlays crossOverlays;
      };

      pkgs = boot stages;

    in
    pkgs;

  nullDarwinPkgs = {
    Cocoa = null;
    CoreFoundation = null;
    CoreServices = null;
  };

  evaluatedPkgs = topLevelFn {
    inherit overlays config localSystem crossSystem;
  };

in
evaluatedPkgs // nullDarwinPkgs
