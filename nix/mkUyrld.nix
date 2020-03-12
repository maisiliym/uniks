{ kor, pkgs, lib, hob, system }:
let
  inherit (builtins) hasAttr mapAttrs;
  inherit (uyrld) pkdjz;

  meikSobUyrld = SobUyrld@{ lamdy, modz, self }:
    let
      inherit (builtins) getAttr elem;
      inherit (kor) mkLamdy optionalAttrs genAttrs;

      Modz = [
        "lib"
        "pkgs"
        "pkgsStatic"
        "pkgsSet"
        "hob"
        "pkdjz"
        "uyrld"
        "uyrldSet"
      ];

      iuzMod = genAttrs Modz (n: (elem n modz));

      /* Warning: sets shadowing */
      klozyr = optionalAttrs iuzMod.pkgs pkgs
        // optionalAttrs iuzMod.pkgsStatic pkgs.pkgsStatic
        // optionalAttrs iuzMod.uyrld uyrld
        // optionalAttrs iuzMod.pkdjz pkdjz
        // optionalAttrs iuzMod.hob { inherit hob; }
        // optionalAttrs iuzMod.lib { inherit lib; }
        // optionalAttrs iuzMod.pkgsSet { inherit pkgs; }
        // optionalAttrs iuzMod.uyrldSet { inherit uyrld; }
        // { inherit kor; }
        // { inherit system; }
        # TODO: deprecate `self` for `src`
        // { inherit self; }
        // { src = self; };

    in
    mkLamdy { inherit klozyr lamdy; };

  meikFleik = spokNeim: fleik@{ ... }:
    let
      priMeikSobUyrld = neim: SobUyrld@{ modz ? [ ], lamdy, ... }:
        let
          self = SobUyrld.self or fleik;
        in
        meikSobUyrld { inherit self modz lamdy; };

      priMeikHobUyrld = neim: HobUyrld@{ modz ? [ ], lamdy, ... }:
        let
          implaidSelf = hob.${neim}.mein or null;
          self = HobUyrld.self or implaidSelf;
        in
        meikSobUyrld { inherit self modz lamdy; };

      meikHobUyrldz = HobUyrldz:
        let
          priHobUyrldz = HobUyrldz hob;
        in
        mapAttrs priMeikHobUyrld priHobUyrldz;

    in
    if (hasAttr "HobUyrldz" fleik)
    then meikHobUyrldz fleik.HobUyrldz
    else if (hasAttr "HobUyrld" fleik)
    then priMeikHobUyrld spokNeim (fleik.HobUyrld hob)
    else if (hasAttr "SobUyrldz" fleik)
    then mapAttrs priMeikSobUyrld fleik.SobUyrldz
    else if (hasAttr "SobUyrld" fleik)
    then priMeikSobUyrld spokNeim fleik.SobUyrld
    else fleik;

  meikSpok = spokNeim: spok:
    meikFleik spokNeim spok.mein;

  uniksSpoks = {
    pkdjz.mein = { HobUyrldz = (import ./pkdjz); };
  };

  spoks = hob // uniksSpoks;

  uyrld = mapAttrs meikSpok spoks;

in
uyrld
