{ self
, lib
, stdenv
, pkg-config
, makeWrapper
, zlib
, bzip2
, gnutls
, guile
, guile-gcrypt
, guile-git
, guile-json
, guile-sqlite3
, guile-ssh
, guile-bytestructures
}:
let
  storeDir = null;
  stateDir = null;

  guile-gnutls = (gnutls.override {
    inherit guile;
    guileBindings = true;
  }).overrideAttrs (attrs: {
    configureFlags = [
      "--with-guile-site-dir=\${out}/share/guile/site"
      "--with-guile-site-ccache-dir=\${out}/share/guile/ccache"
      "--with-guile-extension-dir=\${out}/lib/guile/extensions"
    ];
  });

in
stdenv.mkDerivation rec {
  pname = "guix";
  version = self.shortRev;
  src = self;

  postConfigure = ''
    sed -i '/guilemoduledir\s*=/s%=.*%=''${out}/share/guile/site%' Makefile;
    sed -i '/guileobjectdir\s*=/s%=.*%=''${out}/share/guile/ccache%' Makefile;
  '';

  modules = [
    guile-gcrypt
    guile-git
    guile-json
    guile-sqlite3
    guile-ssh
    guile-gnutls
    guile-bytestructures
  ];

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ zlib bzip2 ] ++ modules;
  propagatedBuildInputs = [ guile ];

  GUILE_LOAD_PATH =
    let
      guilePath = [
        "\${out}/share/guile/site"
        "${guile-gnutls.out}/lib/guile/extensions"
      ] ++ (lib.concatMap
        (module: [
          "${module}/share/guile/site"
        ])
        modules);
    in
    "${lib.concatStringsSep ":" guilePath}";
  GUILE_LOAD_COMPILED_PATH =
    let
      guilePath = [
        "\${out}/share/guile/ccache"
        "${guile-gnutls.out}/lib/guile/extensions"
      ] ++ (lib.concatMap
        (module: [
          "${module}/share/guile/ccache"
        ])
        modules);
    in
    "${lib.concatStringsSep ":" guilePath}";

  configureFlags = [ ]
    ++ lib.optional (storeDir != null) "--with-store-dir=${storeDir}"
    ++ lib.optional (stateDir != null) "--localstatedir=${stateDir}";

  postInstall = ''
    wrapProgram $out/bin/guix \
      --prefix GUILE_LOAD_PATH : "${GUILE_LOAD_PATH}" \
      --prefix GUILE_LOAD_COMPILED_PATH : "${GUILE_LOAD_COMPILED_PATH}"

    wrapProgram $out/bin/guix-daemon \
      --prefix GUILE_LOAD_PATH : "${GUILE_LOAD_PATH}" \
      --prefix GUILE_LOAD_COMPILED_PATH : "${GUILE_LOAD_COMPILED_PATH}"
  '';

  passthru = {
    inherit guile;
  };

  meta = {
    description = "A transactional package manager for an advanced distribution of the GNU system";
    homepage = "https://guix.gnu.org/";
  };
}
