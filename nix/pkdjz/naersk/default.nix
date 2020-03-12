argz@
{ self
, cargo
, darwin
, fetchurl
, jq
, lib
, xorg
, remarshal
, rsync
, runCommand
, rustc
, stdenv
, writeText
, zstd
}:
let
  buildArgz = (removeAttrs argz [ "self" "xorg" ]) // { inherit (xorg) lndir; };
  buildLamdy = import (self + /default.nix);

in
buildLamdy buildArgz
