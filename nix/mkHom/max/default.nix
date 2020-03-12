{ kor, pkgs, krimyn, ... }:
let
  inherit (kor) optionals;
  inherit (krimyn.spinyrz) izUniksDev izSemaDev;

  uniksDevPackages = with pkgs; [
  ];

  semaDevPackages = with pkgs; [
    mindforger
    krita
    calibre
    pandoc
  ];

in
{
  imports = [ ./firefox.nix ];

  home = {
    packages = with pkgs; [
      # freecad # broken
      element-desktop
    ]
    ++ (optionals izUniksDev uniksDevPackages)
    ++ (optionals izSemaDev semaDevPackages);
  };

  programs = {
    chromium = {
      enable = true;
      extensions = [
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        {
          id = "dcpihecpambacapedldabdbpakmachpb";
          updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
        }
      ];
    };
  };
}
