{ kor, lib, src, meikPkgs, hob }:
let
  emacs-overlay = src;
  pkgs = meikPkgs { overlays = [ emacs-overlay.overlay ]; };
  inherit (pkgs) writeText emacsPackagesFor emacsPgtkGcc;
  emacsPackages = emacsPackagesFor emacsPgtkGcc;
  inherit (emacsPackages) elpaBuild withPackages melpaBuild;
  parseLib = import (emacs-overlay + /parse.nix)
    { inherit pkgs lib; };
  inherit (parseLib) parsePackagesFromUsePackage;

  customPackages = {
    shen-mode =
      let src = hob.shen-mode.mein; in
      melpaBuild {
        pname = "shen-mode";
        inherit src;
        commit = src.rev;
        version = "0.1";
        recipe = pkgs.writeText "recipe" ''
          (shen-mode
           :repo "NHALX/shen-mode"
           :fetcher github)
        '';
      };
  };

  overiddenEmacsPackages = emacsPackages // customPackages;

in
{ kriozon, krimyn, profile }:
let
  inherit (builtins) readFile concatStringsSep;

  launcher = "vertico"; # TODO profile

  imaksTheme =
    if profile.dark then "'modus-vivendi"
    else "'modus-operandi";

  initEl = (readFile ./init.el) +
    ''
      (load-theme ${imaksTheme} t)
    '';

  commonPackagesEl = readFile ./packages.el;
  launcherCommonEl = readFile ./vertico-selectrum-common.el;
  launcherStyleEl = (if (launcher == "vertico") then
    (readFile ./vertico.el) else (readFile ./selectrum.el));

  packagesEl = concatStringsSep "\n"
    [ commonPackagesEl launcherCommonEl launcherStyleEl ];

  usePackagesNames = kor.unique
    (parsePackagesFromUsePackage {
      configText = packagesEl;
      alwaysEnsure = true;
    });

  mkPackageError = name:
    builtins.trace
      "Emacs package ${name}, declared wanted with use-package, not found."
      null;

  findPackage = name: overiddenEmacsPackages.${name}  or (mkPackageError name);
  usePackages = map findPackage usePackagesNames;

  elpaHeader = readFile ./elpaHeader.el;
  elpaFooter = ";;; default.el ends here";
  defaultEl = elpaHeader + initEl + packagesEl + elpaFooter;

  defaultElPackage = elpaBuild {
    pname = "default-el";
    version = kor.cortHacString defaultEl;
    src = writeText "default.el" defaultEl;
    packageRequires = usePackages;
  };

  imaksPackages = usePackages ++ [ defaultElPackage ];
  imaks = withPackages imaksPackages;

in
imaks
