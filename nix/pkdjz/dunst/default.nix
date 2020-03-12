{ self
, stdenv
, lib
, makeWrapper
, pkg-config
, which
, perl
, xorg
, cairo
, dbus
, systemd
, gdk-pixbuf
, glib
, libnotify
, pango
, librsvg
, wayland
, wayland-protocols
, dunstify ? false
}:

stdenv.mkDerivation {
  pname = "dunst";
  version = self.shortRev;
  src = self;

  nativeBuildInputs = [ perl pkg-config which systemd makeWrapper ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    libnotify
    pango
    librsvg
    wayland
    wayland-protocols
  ] ++ (with xorg; [
    xorgproto
    libX11
    libXScrnSaver
    libXinerama
    libXrandr
  ]);

  outputs = [ "out" "man" ];

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=$(version)"
    "SERVICEDIR_DBUS=$(out)/share/dbus-1/services"
    "SERVICEDIR_SYSTEMD=$(out)/lib/systemd/user"
    "SYSCONFDIR=$(out)/share/etc"
    "WAYLAND=1"
  ];

  buildFlags = if dunstify then [ "dunstify" ] else [ ];

  postInstall = lib.optionalString dunstify ''
    install -Dm755 dunstify $out/bin
    sed -i 's/^SystemdService=.*$//' $out/share/dbus-1/services/org.knopwob.dunst.service
  '' + ''
    wrapProgram $out/bin/dunst \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';
}
