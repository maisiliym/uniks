{ kor, system, shen, uniks }:
let
  inherit (kor) mesydj mkImplicitVersion;
in
inputs@
{ name
, src
, uniksShen ? null
, version ? mkImplicitVersion src
, uniksLib ? uniks.lib
, nixInputs ? { }
}:
let
  inherit (builtins) pathExists concatStringsSep;
  name = concatStringsSep "-" [ inputs.name version ];
  uniksLibPath = uniksLib + uniks.libSuffixPath;

  explicitBuildFile = builtins.toFile "drvcn-${name}.shen"
    uniksShen;

  implicitBuildFile =
    let
      filePath = src + /fleik.shen;
      legacyFilePath = src + /flake.shen;
      fileExists = pathExists filePath;
      legacyFileExists = pathExists legacyFilePath;
      atLeastOneFilePresent = fileExists || legacyFileExists;
    in
    assert mesydj atLeastOneFilePresent
      "File ${filePath} missing";
    if fileExists then filePath else legacyFilePath;

  buildFile =
    if (uniksShen != null)
    then explicitBuildFile
    else implicitBuildFile;

in
derivation {
  inherit name system src shen nixInputs;

  builder = shen + /bin/shen;

  args = [ "eval" "--load" uniksLibPath "--load" buildFile ];

  __structuredAttrs = true;
}
