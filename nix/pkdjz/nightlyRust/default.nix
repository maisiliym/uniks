{ self, mozPkgs }:
let
  inherit (mozPkgs) rustChannelOf;

  date = "2021-01-30";
  sha256 = "IcRjasxykQgHCInQ6dZp+bfBcuR/Inm8jhfzTkZrDEM=";

in
rustChannelOf {
  inherit date sha256;
  channel = "nightly";
}
