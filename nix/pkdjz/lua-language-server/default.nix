{ self
, luajit
, ninja
, makeWrapper
}:
let
  inherit (luajit.pkgs) buildLuarocksPackage;

in
buildLuarocksPackage {
  pname = "lua-language-server";
  version = self.shortRev;
  src = self;

  nativeBuildInputs = [ ninja makeWrapper ];

  unpackPhase = ''
    mkdir source
    cd source
    cp -r $src/* ./
    chmod -R u+w ./
  '';

  buildPhase = ''
    cd 3rd/luamake
    ninja -f ninja/linux.ninja
    cd ../..
    ./3rd/luamake/luamake rebuild
  '';

  installPhase = ''
    mkdir -p $out/bin $out/extras
    cp -r ./{locale,meta,script,*.lua} $out/extras/
    cp ./bin/Linux/{bee.so,lpeglabel.so} $out/extras
    cp ./bin/Linux/lua-language-server $out/extras/.lua-language-server-unwrapped
    makeWrapper $out/extras/.lua-language-server-unwrapped \
      $out/bin/lua-language-server \
      --add-flags "-E $out/extras/main.lua \
      --logpath='~/.cache/sumneko_lua/log' \
      --metapath='~/.cache/sumneko_lua/meta'"
  '';

  meta = {
    description = "Lua Language Server coded by Lua ";
    homepage = "https://github.com/sumneko/lua-language-server";
  };
}
