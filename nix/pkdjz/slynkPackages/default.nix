{ emacsPackages
, lispPackages
}:
let
  trivialBuild = args@{ baseName, ... }:
    lispPackages.buildLispPackage ({
      inherit baseName;
      description = baseName;
      packageName = baseName;
      buildSystems = [ baseName ];
      asdFilesToKeep = [ "${baseName}.asd" ];
    } // args);

  slynk = trivialBuild rec {
    baseName = "slynk";
    deps = [
      lispPackages.bordeaux-threads
    ];
    inherit (emacsPackages.sly) version src;
    overrides = p: {
      postUnpack = "src=$src/slynk";
    };
    buildSystems = [
      "slynk"
      "slynk/mrepl"
      "slynk/arglists"
      "slynk/package-fu"
      "slynk/stickers"
      "slynk/indentation"
      "slynk/retro"
    ];
  };

  slynk-quicklisp = trivialBuild rec {
    baseName = "slynk-quicklisp";
    deps = [
      slynk
      lispPackages.quicklisp
    ];
    inherit (emacsPackages.sly-quicklisp) src version;
  };

  slynk-asdf = trivialBuild rec {
    baseName = "slynk-asdf";
    deps = [
      slynk
    ];
    inherit (emacsPackages.sly-asdf) src version;
  };

  slynk-named-readtables = trivialBuild rec {
    baseName = "slynk-named-readtables";
    deps = [
      slynk
    ];
    inherit (emacsPackages.sly-named-readtables) src version;
  };

  slynk-macrostep = trivialBuild rec {
    baseName = "slynk-macrostep";
    deps = [
      slynk
    ];
    inherit (emacsPackages.sly-macrostep) src version;
  };

in
{
  inherit slynk slynk-quicklisp slynk-asdf slynk-named-readtables
    slynk-macrostep;
}
