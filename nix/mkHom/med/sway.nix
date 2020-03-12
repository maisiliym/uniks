{ kor, pkgs, pkdjz, krimyn, config, profile, ... }:
let
  inherit (builtins) readFile mapAttrs;
  inherit (kor) mkIf optionals optionalString matcSaiz;
  inherit (krimyn.spinyrz) saizAtList iuzColemak izUniksDev izSemaDev;
  inherit (krimyn) saiz;
  inherit (profile) dark;
  inherit (pkgs) writeText;

  waylandQtpass = pkgs.qtpass.override { pass = waylandPass; };
  waylandPass = pkgs.pass.override { x11Support = false; waylandSupport = true; };

  shellLaunch = command: "${shell} -c '${command}'";
  homeDir = config.home.homeDirectory;
  nixProfileExec = name: "${homeDir}/.nix-profile/bin/${name}";

  shell = nixProfileExec "mksh";
  zshEksek = nixProfileExec "zsh";
  neovim = nixProfileExec "nvim";
  elementaryCode = nixProfileExec "io.elementary.code";
  termVis = shellLaunch "exec ${terminal} -e  ${nixProfileExec "vis"}";
  termNeovim = shellLaunch "exec ${terminal} -e ${neovim}";
  termBrowser = shellLaunch "exec ${terminal} -e ${nixProfileExec "w3m"}";
  terminal = matcSaiz saiz "" "${nixProfileExec "foot"}" "${nixProfileExec "foot"}" "${nixProfileExec "foot"}";

  swayArgz = {
    inherit iuzColemak optionalString;
    waybarEksek = nixProfileExec "waybar";
    swaylockEksek = nixProfileExec "swaylock";
    browser = matcSaiz saiz "" termBrowser "${nixProfileExec "qutebrowser"}" "${nixProfileExec "qutebrowser"}";
    launcher = "${nixProfileExec "wofi"} --show drun";
    shellTerm = shellLaunch "export SHELL=${zshEksek}; exec ${terminal} ${zshEksek}";
  };

  fontDeriveicynz = [ pkgs.noto-fonts-cjk ]
    ++ (optionals saizAtList.med [
    pkdjz.nerd-fonts.firaCode
    pkgs.fira-code
  ]);


  mkFootSrcTheme = themeName:
    let
      themeString = readFile (pkgs.foot.src + "/themes/${themeName}");
    in
    writeText "foot-theme-${themeName}" themeString;

  footThemeFile =
    let
      darkTheme = mkFootSrcTheme "derp";
      lightTheme = mkFootSrcTheme "selenized-white";
    in
    if dark then darkTheme else lightTheme;

  mkFcCache = pkgs.makeFontsCache { fontDirectories = fontDeriveicynz; };

  mkFontPaths = kor.concatMapStringsSep "\n"
    (path: "<dir>${path}/share/fonts</dir>")
    fontDeriveicynz;

  mkFontConf = ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>
      ${mkFontPaths}
      <cachedir>${mkFcCache}</cachedir>
    </fontconfig>
  '';

  mkSoundScript = sound:
    pkgs.writeScript "soundScript" ''
      #!${pkgs.mksh}/bin/mksh
      mpv ${sound}
    '';

  swayConfigString = import ./swayConf.nix swayArgz;

in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures = { base = true; gtk = true; };
    systemdIntegration = true;
    extraSessionCommands = '' '';
    config = null;
    extraConfig = swayConfigString;
  };

  services = {
    dunst = {
      enable = true;
      package = pkdjz.dunst;
      waylandDisplay = "wayland-0";
      settings = {
        global = {
          geometry = "300x5-30+50";
          transparency = 10;
          frame_color = "#eceff1";
          font = "Fira Code 10";
        };

        urgency_normal = {
          background = "#37474f";
          foreground = "#eceff1";
          timeout = 10;
        };

        dino = {
          desktop_entry = "im.Dino.dino";
          # script = toString (mkSoundScript soundTheme.notification);
        };
      };
    };

    redshift = {
      enable = true;
      package = pkgs.redshift-wlr;
      provider = "geoclue2";
      temperature = {
        day = 6000;
        night = 2700;
      };
    };

  };

  xdg.configFile = {
    "fontconfig/conf.d/10-niksIuzyr-fonts.conf".text = mkFontConf;
  };

  programs = {
    foot = {
      enable = true;
      settings = {
        main = {
          include = toString footThemeFile;
          font = "Fira Code:size=9";
        };
      };
    };
  };

  home = {
    packages = with pkgs; [
      # C
      # ctags
      swaylock
      grim
      waybar
      zathura
      wl-clipboard
      libnotify
      imv
      wf-recorder
      libva-utils
      ffmpeg
      # start("GTK")
      wofi
      gitg
      pavucontrol
      dino
      transmission-remote-gtk
      ptask
      bookworm
      pantheon.elementary-files
      pantheon.elementary-code
      # start("Qt")
      nheko
      adwaita-qt
      qgnomeplatform
      waylandQtpass
      qtox
      waylandPass
      qjackctl
      # TODO('hyraizyn language')
      (hunspellWithDicts [ hunspellDicts.en-us-large ])
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      hunspellDicts.en-us-large
    ]
    ++ (optionals izUniksDev (with pkgs; [
    ]))
    ++ (optionals izSemaDev (with pkgs; [
      inkscape
      shotwell
      gthumb
    ]));

    file = {
      ".config/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-application-prefer-dark-theme=${if dark then "1" else "0"}
      '';

      ".config/IJHack/QtPass.conf".text = ''
        [General]
        autoclearSeconds=20
        passwordLength=32
        useTrayIcon=false
        hideContent=false
        hidePassword=true
        clipBoardType=1
        hideOnClose=false
        passExecutable=${waylandPass}/bin/pass
        passTemplate=login\nurl
        pwgenExecutable=${pkgs.pwgen}bin/pwgen
        startMinimized=false
        templateAllFields=false
        useAutoclear=true
        useTrayIcon=false
        version=${pkgs.qtpass.version}
      '';

    };
  };
}
