{ kor, lib, kriosfir }:
let
  inherit (builtins) mapAttrs;
  inherit (lib) evalModules;

  metastriz = kriosfir;

  hyraizynOptions = import ./hyraizynOptions.nix;
  mkHyraizynModule = import ./mkHyraizynModule.nix;

  mkKriozon = neksysNeim: priNeksysNeim:
    let
      astraNeim = priNeksysNeim;
      metastraNeim = neksysNeim;

      argzModule = {
        config = {
          inherit astraNeim metastraNeim;
          _module.args = {
            inherit kor lib;
            Metastriz = metastriz.datom;
            metastrizSpiciz = metastriz.spiciz;
          };
        };
      };

      ivaliueicyn = evalModules {
        modules = [
          argzModule
          hyraizynOptions
          mkHyraizynModule
        ];
      };

      kriozon = ivaliueicyn.config.hyraizyn;

    in
    kriozon;

  mkNeksysKriozonz = neksysNeim: neksys:
    # let priNeksysNeimz = attrNames neksys.astriz; in
    mapAttrs (pnn: pn: mkKriozon neksysNeim pnn) neksys.astriz;

  ryzylt = mapAttrs mkNeksysKriozonz kriosfir.datom;

in
ryzylt
