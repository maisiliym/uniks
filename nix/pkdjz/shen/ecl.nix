{ lib
, stdenv
, fetchurl
, shen-sources
, ecl
}:

stdenv.mkDerivation rec {
  pname = "shen-ecl";
  version = "3.0.3";

  src = fetchurl {
    url = "https://github.com/Shen-Language/shen-cl/releases/download/v${version}/shen-cl-v${version}-sources.tar.gz";
    sha256 = "0mc10jlrxqi337m6ngwbr547zi4qgk69g1flz5dsddjy5x41j0yz";
  };

  buildInputs = [ ecl ];

  preBuild = ''
    ln -s ${shen-sources} kernel
  '';

  buildFlags = [ "build-ecl" ];

  checkTarget = "test-ecl";

  doCheck = true;

  installPhase = ''
    install -m755 -D bin/ecl/shen $out/bin/shen
  '';

  meta = with lib; {
    homepage = "https://shenlanguage.org";
    description = "Port of Shen running on ECL";
    changelog = "https://github.com/Shen-Language/shen-cl/raw/v${version}/CHANGELOG.md";
    platforms = ecl.meta.platforms;
  };
}
