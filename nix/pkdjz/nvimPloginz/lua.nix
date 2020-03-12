{ hob, bildNvimPlogin, fzf }:
let
  inherit (builtins) mapAttrs;

  implaidSpoks = {
    inherit (hob)
      nvim-lspconfig
      ;
  };

  eksplisitSpoks = {
    plenary-kor = hob.plenary-nvim.mein;
  };

  spoks = eksplisitSpoks
    // (mapAttrs (n: s: s.mein) implaidSpoks);

  ovyraidzIndeks = {
    plenary-kor = {
      installPhase = ''
        runHook preInstall
        mkdir -p $out/lua
        cp -r lua/plenary $out/lua/
        runHook postInstall
      '';
    };
  };

  bildNvimLuaPlogin = { neim, self, ovyraidz }:
    let
    in
    bildNvimPlogin ({
      pname = neim;
      version = self.shortRev;
      src = self;
      namePrefix = "nvimLuaPlogin";
      components = [ "lua" "queries" "doc" ];
    } // ovyraidz);

  mkSpok = neim: self:
    let
      ovyraidz = ovyraidzIndeks.${neim} or { };
    in
    bildNvimLuaPlogin { inherit neim self ovyraidz; };

  ryzylt = mapAttrs mkSpok spoks;

in
ryzylt
