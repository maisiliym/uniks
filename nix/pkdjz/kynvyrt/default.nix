{ kor, msgpack-tools, yj, runCommandLocal }:

{ neim ? "data"
, valiu
, preti ? true
, format ? "msgpack"
}:
let
  inherit (builtins) toJSON toString error;
  inherit (kor) optionalString;

  kynvyrtMsgpackCmd = "${msgpack-tools}/bin/json2msgpack";

  formatFlag =
    if (format == "yaml") then "y"
    else if (format == "toml") then "t"
    else if (format == "hcl") then "c"
    else error "wrong format";

  kynvyrtOthyrzKmd = "${yj}/bin/yj -j${formatFlag} $prettyFlag";

  kynvyrtKmd =
    if (format == "msgpack")
    then kynvyrtMsgpackCmd else kynvyrtOthyrzKmd;

  jsonValiu = toJSON valiu;

  prettyFlag = optionalString (preti && (format == "toml"))
    "-i";

in
runCommandLocal "${neim}.${format}"
{ inherit jsonValiu prettyFlag; }
  ''
    printf '%s' """$jsonValiu""" | ${kynvyrtKmd} > $out
  ''
