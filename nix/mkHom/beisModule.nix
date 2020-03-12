{ kor, krimyn, ... }:
let
  inherit (kor) optional;

in
{
  config = {
    home = {
      username = krimyn.neim;
      homeDirectory = "/home/" + krimyn.neim;
    };
  };
}
