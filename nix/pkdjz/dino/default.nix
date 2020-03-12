{ self
, stdenv
, vala
, cmake
, ninja
, wrapGAppsHook
, pkgconfig
, gettext
, gobject-introspection
, gnome3
, glib
, gdk-pixbuf
, gtk3
, glib-networking
, xorg
, libxkbcommon
, libnotify
, libsoup
, libgee
, librsvg
, libsignal-protocol-c
, fetchpatch
, libgcrypt
, epoxy
, at-spi2-core
, sqlite
, dbus
, gpgme
, pcre
, qrencode
, icu
, gspell
}:

stdenv.mkDerivation rec {
  pname = "dino";
  version = self.shortRev;
  src = self;

  nativeBuildInputs = [
    vala
    cmake
    ninja
    pkgconfig
    wrapGAppsHook
    gettext
  ];

  buildInputs = [
    qrencode
    gobject-introspection
    glib-networking
    glib
    libgee
    gnome3.adwaita-icon-theme
    sqlite
    gdk-pixbuf
    gtk3
    libnotify
    gpgme
    libgcrypt
    libsoup
    pcre
    xorg.libxcb
    xorg.libpthreadstubs
    xorg.libXdmcp
    libxkbcommon
    epoxy
    at-spi2-core
    dbus
    icu
    libsignal-protocol-c
    librsvg
    gspell
  ];

  meta = {
    description = "Modern Jabber/XMPP Client using GTK/Vala";
    homepage = "https://github.com/dino/dino";
  };
}
