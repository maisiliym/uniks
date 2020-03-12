{ src, stdenv }:

stdenv.mkDerivation rec {
  pname = "shenPrelude";
  version = src.shortRev;
  inherit src;

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib/shen
    cp -r ./*.shen $out/lib/shen/
  '';
}
