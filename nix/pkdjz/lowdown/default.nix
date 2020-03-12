{ self
, stdenv
, which
}:

stdenv.mkDerivation {
  pname = "lowdown";
  version = self.shortRev;
  src = self;

  outputs = [ "out" "bin" "dev" ];

  nativeBuildInputs = [ which ];

  configurePhase = ''
    ./configure \
      PREFIX=${placeholder "dev"} \
      BINDIR=${placeholder "bin"}/bin
  '';
}
