{ kor
, stdenv
, neovim
}:
let
  inherit (builtins) elem all;
  inherit (kor) mesydj;

  allowedComponents = [
    "bin"
    "lua"
    "filetype.vim"
    "scripts.vim"
    "autoload"
    "colors"
    "doc"
    "ftplugin"
    "indent"
    "keymap"
    "plugin"
    "queries"
    "rplugin"
    "syntax"
  ];

in
argz@
{ pname
, version
, src
, namePrefix ? "nvimPlogin"
, unpackPhase ? ""
, configurePhase ? ":"
, buildPhase ? ":"
, installPhase ? ""
, preInstall ? ""
, postInstall ? ""
, components ? [ ]
, ...
}:
assert mesydj (all (c: elem c allowedComponents) components)
  "Component not allowed in: ${toString components}";
let
  inherit (builtins) readDir concatStringsSep;
  inherit (kor) intersectLists mapAttrsToList optionalString;

  srcDirs = readDir src;

  checkSrcComponent = dirNeim: fileType:
    optionalString (fileType == "directory") dirNeim;

  srcComponents = mapAttrsToList checkSrcComponent srcDirs;

  components = intersectLists srcComponents
    (argz.components or allowedComponents);

in
stdenv.mkDerivation (argz // {
  name = concatStringsSep "-"
    [ namePrefix pname version ];

  inherit unpackPhase configurePhase buildPhase preInstall postInstall components;

  installPhase = ''
    runHook preInstall
  ''
  + (if ((argz.installPhase or "") != "")
  then argz.installPhase else
    ''
      mkdir -p $out
      for dir in ''${components[@]}; do
      cp -r $dir $out
      done
    '')
  + # build help tags
  ''
    if [ -d "$out/doc" ]; then
    echo "Building help tags"
    if ! ${neovim}/bin/nvim -N -u NONE -i NONE -n -E -s -V1 -c "helptags $out/doc" +quit!; then
    echo "Failed to build help tags!"
    exit 1
    fi
    else
    echo "No docs available"
    fi

    runHook postInstall
  '';
})
