{ self
, stdenv
, lib
, cmake
, gettext
, msgpack
, libtermkey
, libiconv
, libuv
, luajit
, ncurses
, pkgconfig
, unibilium
, wl-clipboard
, gperf
, libvterm-neovim
, utf8proc
, tree-sitter
}:
let
  neovimLuaEnv = luajit.withPackages (ps: (with ps; [ lpeg luabitop mpack ]));

in
stdenv.mkDerivation {
  pname = "neovim";
  version = self.shortRev;
  src = self;

  patches = [
    ./system_rplugin_manifest.patch
  ];

  dontFixCmake = true;
  enableParallelBuilding = true;

  buildInputs = [
    gperf
    libtermkey
    libuv
    libvterm-neovim
    luajit.pkgs.luv.libluv
    msgpack
    ncurses
    neovimLuaEnv
    unibilium
    utf8proc
    tree-sitter
  ];

  doCheck = false;

  checkPhase = ''
    make functionaltest
  '';

  nativeBuildInputs = [
    cmake
    gettext
    pkgconfig
  ];


  postPatch = ''
    substituteInPlace src/nvim/version.c --replace NVIM_VERSION_CFLAGS "";
  '';

  disallowedReferences = [ stdenv.cc ];

  cmakeFlags = [
    "-DGPERF_PRG=${gperf}/bin/gperf"
    "-DLUA_PRG=${neovimLuaEnv.interpreter}"
    "-DLIBLUV_LIBRARY=${luajit.pkgs.luv}/lib/lua/${luajit.luaversion}/luv.so"
  ];

  hardeningDisable = [ "fortify" ];

  postInstall = ''
    sed -i -e "s|'wl-copy|'${wl-clipboard}/bin/wl-copy|g" $out/share/nvim/runtime/autoload/provider/clipboard.vim
  '';

  shellHook = ''
    export VIMRUNTIME=$PWD/runtime
  '';

  meta = {
    description = "Vim text editor fork focused on extensibility and agility";
    longDescription = ''
      Neovim is a project that seeks to aggressively refactor Vim in order to:
      - Simplify maintenance and encourage contributions
      - Split the work between multiple developers
      - Enable the implementation of new/modern user interfaces without any
      modifications to the core source
      - Improve extensibility with a new plugin architecture
    '';
    homepage = https://www.neovim.io;
  };
}
