{ kor, src, writeText, stdenv, shen, shenPrelude, deryveicyn, asdf, buildEnv }:
let
  inherit (kor) mkImplicitVersion;

  uiopEntryFile = asdf + /lib/common-lisp/uiop/driver.lisp;

  uiopShen = writeText "uiop.shen" ''
    (shen-cl.load-lisp "${uiopEntryFile}")
  '';

  libSuffixPath = "/lib/shen/lib.shen";

  bootstrapUniksLib = stdenv.mkDerivation {
    pname = "bootstrapUniksLib";
    version = mkImplicitVersion src;
    inherit src;

    buildInputs = [ asdf ];

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      mkdir -p $out/lib/shen
      cp -r ./*.shen $out/lib/shen/
      rm $out/lib/shen/fleik.shen
      ln -s ${uiopShen} $out/lib/shen/uiop.shen
    '';
  };

  uniksEnv = buildEnv {
    name = "uniksEnv";
    paths = [ uniksLib ];
  };

  uniksLib = deryveicyn {
    name = "uniksLib";
    uniksLib = bootstrapUniksLib;
    inherit src;
    nixInputs = { inherit asdf; };
  };

in
{ inherit uniksLib uniksEnv libSuffixPath; }
