{ self
, luajit
}:
let
  inherit (luajit.pkgs) buildLuarocksPackage;

in
buildLuarocksPackage {
  pname = "LuaFormatter";
  version = self.shortRev;
  src = self;

  unpackPhase = ''
    mkdir source
    cd source
    cp -r $src/* ./
    chmod -R u+w ./
  '';

}
