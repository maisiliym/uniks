{ pkdjz, krimyn, kriozon, profile, ... }:
let
  inherit (pkdjz) meikImaks slynkPackages;
  package = meikImaks { inherit kriozon krimyn profile; };

  slynkPkgs = with slynkPackages; [
    slynk # slynk-asdf slynk-quicklisp slynk-macrostep
  ];

in
{
  home = {
    packages = [ package ] ++ slynkPkgs;

    sessionVariables = {
      EDITOR = "emacsclient -c";
    };
  };

  services = {
    emacs = {
      enable = true;
      inherit package;
    };
  };
}
