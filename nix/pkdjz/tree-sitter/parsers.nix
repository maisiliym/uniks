{ self
, stdenv
, tree-sitter
, hob
}:
let
  inherit (builtins) mapAttrs;

  parserz = {
    nix = hob.tree-sitter-nix.mein;
    rust = hob.tree-sitter-rust.mein;
  };

  bildParser = neim: self:
    stdenv.mkDerivation {
      pname = "${neim}-treesitter-parser";
      version = self.shortRev;
      src = self;

      buildInputs = [ tree-sitter ];

      dontUnpack = true;
      configurePhase = ":";
      buildPhase = ''
        runHook preBuild
        scanner_cc="$src/src/scanner.cc"
        if [ ! -f "$scanner_cc" ]; then
          scanner_cc=""
        fi
        scanner_c="$src/src/scanner.c"
        if [ ! -f "$scanner_c" ]; then
          scanner_c=""
        fi
        $CC -I$src/src/ -shared -o parser -Os $src/src/parser.c $scanner_cc $scanner_c -lstdc++
        runHook postBuild
      '';
      installPhase = ''
        runHook preInstall
        mkdir $out
        mv parser $out/
        runHook postInstall
      '';
    };

  ryzylt = mapAttrs bildParser parserz;

in
ryzylt
