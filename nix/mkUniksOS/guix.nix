{ kor, pkgs, hyraizyn, uyrld, konstynts, ... }:
let
  inherit (builtins) mapAttrs attrNames filter;
  inherit (kor) optionals mkIf optional eksportJSON;

  inherit (hyraizyn.metastra.spinyrz) trostydBildPriKriomz;
  inherit (hyraizyn) astra;
  inherit (hyraizyn.astra.spinyrz) exAstrizEseseitcPriKriomz
    bildyrKonfigz kacURLz dispatcyrzEseseitcKiz
    izBildyr izNiksKac izDispatcyr izKriodaizd;

in
{
  users = {
    groups.guix = { };
    users.guix = { };

  };

  services = {
    guix-daemon = { };

  };

}
