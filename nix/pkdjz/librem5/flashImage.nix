{ src
, stdenv
, python3Packages
, help2man
, appstream
}:

stdenv.mkDerivation {
  name = "librem5-flash-image";
  inherit src;
  version = src.shortRev;

  nativeBuildInputs = with python3Packages; [
    wrapPython
    help2man
  ];

  propagatedBuildInputs = with python3Packages; [
    python
    flake8
    appstream
    coloredlogs
    python-jenkins
    pyyaml
    requests
    tqdm
  ];

  installFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    wrapPythonPrograms
  '';

}
