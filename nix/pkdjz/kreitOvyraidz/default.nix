{ kor
, systemd
, cryptsetup
, llvmPackages
, pkgconfig
, utillinux
, cmake
, python2
, fontconfig
, bzip2
, freetype
, expat
}:
let
  inherit (kor) concatMapStringsSep;

  inherit (llvmPackages) libclang;

  cryptsetupDev = cryptsetup.dev;

  clang = llvmPackages.clang-unwrapped;

  mkClangIncludes = list:
    concatMapStringsSep " " (x: "--include-directory=${x}") list;

in
{
  pkg-config = attrs: {
    buildInputs = [ pkgconfig ];
  };

  libudev-sys = attrs: {
    PKG_CONFIG_PATH = "${systemd.dev}/lib/pkgconfig";
    buildInputs = [ pkgconfig systemd.dev ];
  };

  libcryptsetup-rs-sys = attrs: {
    PKG_CONFIG_PATH = "${cryptsetupDev}/lib/pkgconfig";
    LIBCLANG_PATH = "${libclang}/lib";
    BINDGEN_EXTRA_CLANG_ARGS = mkClangIncludes [ "${cryptsetupDev}/include" "${clang}/lib/clang/${clang.version}/include/" ];
    buildInputs = [ pkgconfig cryptsetupDev libclang ];
  };

  libcryptsetup-rs = attrs: {
    buildInputs = [ pkgconfig cryptsetupDev ];
  };

  libstratis = attrs: {
    buildInputs = [ pkgconfig cryptsetupDev utillinux ];
  };

  expat-sys = attrs: {
    buildInputs = [ pkgconfig expat cmake ];
  };

  skia-bindings = attrs: {
    buildInputs = [ python2 ];
  };

  servo-fontconfig-sys = attrs: {
    buildInputs = [ pkgconfig fontconfig ];
  };

  bzip2-sys = attrs: {
    buildInputs = [ pkgconfig bzip2 ];
  };

  freetype-sys = attrs: {
    buildInputs = [ pkgconfig freetype cmake ];
  };

}
