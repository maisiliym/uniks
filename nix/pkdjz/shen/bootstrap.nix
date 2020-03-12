{ stdenv, src, sbcl }:

stdenv.mkDerivation {
  pname = "shen";
  version = "31.01";
  inherit src;

  buildInputs = [ sbcl ];

  buildPhase = ''
    sbcl --eval '(load "install.lsp")'
  '';

  installPhase = ''
    install -m755 -D ./sbcl-shen.exe $out/bin/shen
  '';

  doCheck = false; # (blockedBy shenIsReplOnly)

  dontStrip = true; # (blockedBy staticLinking)

  meta = {
    homepage = "https://shenlanguage.org";
    description = "Shen language SBCL implementation";
  };
}
