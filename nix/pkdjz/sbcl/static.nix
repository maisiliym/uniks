{ src
, lib
, stdenv
, pkgs
, texinfo
}:
let
  inherit (pkgs) sbcl;

  threadSupport = with stdenv;
    (isi686 || isx86_64 || "aarch64-linux" == hostPlatform.system);

  version = src.shortRev;

  sbclBootstrapHost = "${sbcl}/bin/sbcl --disable-debugger --no-userinit --no-sysinit";

  enableFeatures = with lib;
    [ "sb-linkable-runtime" "sb-prelink-linkage-table" ] ++
    optional threadSupport "sb-thread" ++
    optional stdenv.isAarch32 "arm";

  disableFeatures = with lib;
    optional (!threadSupport) "sb-thread";

in
stdenv.mkDerivation {
  pname = "sbcl";
  inherit version src enableFeatures disableFeatures;

  buildInputs = [ texinfo ];

  postPatch = ''
    echo '"${version}.nixos"' > version.lisp-expr

    sed -i -e "s/CFLAGS += -marm -march=armv5/CFLAGS += -marm/" src/runtime/Config.arm-linux
  '';

  preBuild = ''
    export INSTALL_ROOT=$out
    mkdir -p test-home
    export HOME=$PWD/test-home
  '';


  buildPhase = ''
    runHook preBuild

    sh make.sh --prefix=$out --xc-host="${sbclBootstrapHost}" ${
                  lib.concatStringsSep " "
                    (builtins.map (x: "--with-${x}") enableFeatures ++
                     builtins.map (x: "--without-${x}") disableFeatures)
                }
    (cd doc/manual ; make info)

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    INSTALL_ROOT=$out sh install.sh

    runHook postInstall
  '';

  doCheck = false;

  meta = sbcl.meta // {
    updateWalker = true;
  };
}
