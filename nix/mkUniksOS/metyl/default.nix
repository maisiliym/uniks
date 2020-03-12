{ lib, hyraizyn, kor, config, pkgs, ... }:
let
  inherit (builtins) readFile;
  inherit (kor) mkIf optional optionals optionalString optionalAttrs;
  inherit (hyraizyn.astra.spinyrz) saizAtList tcipIzIntel modylIzThinkpad
    impozyzHaipyrThreding iuzColemak izSentyr izEdj computerIs;

  izX230 = hyraizyn.astra.mycin.modyl == "ThinkPad X230";
  izX240 = hyraizyn.astra.mycin.modyl == "ThinkPad X240";

in
{
  hardware = {
    firmware = with pkgs; [
      firmwareLinuxNonfree
      intel2200BGFirmware
      rtl8192su-firmware
      rtl8723bs-firmware
      rtlwifi_new-firmware
      zd1211fw
      alsa-firmware
      openelec-dvb-firmware
    ]
    ++ optional computerIs.rpi3B raspberrypiWirelessFirmware;

    opengl.extraPackages = optional tcipIzIntel pkgs.vaapiIntel;

  };

  location.provider = if saizAtList.min then "geoclue2" else "manual";

  boot = {
    extraModulePackages = [ ] ++
      (optional modylIzThinkpad config.boot.kernelPackages.acpi_call);

    kernelModules = [ "coretemp" ];

    kernelParams = (optional tcipIzIntel "intel_pstate=disable")
      ++ (optionals computerIs.rpi3B [
      "cma=32M"
      "console=ttyS0,115200n8"
      "console=ttyAMA0,11520n8"
      "console=tty0"
      "dtparam=audio=on"
    ]);

  };

  powerManagement = {
    powerUpCommands = optionalString impozyzHaipyrThreding (readFile ./softDisableHT.sh);
    powerDownCommands = optionalString impozyzHaipyrThreding (readFile ./softEnableHT.sh);
  };

  programs.light.enable = !izSentyr;

  console.useXkbConfig = iuzColemak;

  environment = {
    systemPackages = optional tcipIzIntel pkgs.libva-utils;

    interactiveShellInit = optionalString iuzColemak "stty -ixon"; # Disable Flow-control pause stone-age artifact;
    sessionVariables = (optionalAttrs iuzColemak {
      XKB_DEFAULT_LAYOUT = "us";
      XKB_DEFAULT_VARIANT = "colemak";
    });
  };

  users.groups.plugdev = { };

  services = {
    geoclue2 = {
      enable = saizAtList.min;
      enableDemoAgent = lib.mkOverride 0 true;
      appConfig.redshift = {
        isAllowed = true;
        isSystem = true;
      };
    };

    localtime = { enable = saizAtList.min; };

    udev.extraRules = ''
      # USBasp - USB programmer for Atmel AVR controllers
      SUBSYSTEM=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05dc", GROUP="plugdev"
      # Pro-micro kp-boot-bootloader - Ergodone keyboard
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="bb05", GROUP="plugdev"
      SUBSYSTEM!="usb", GOTO="librem5_rules_end"
      # Librem 5 USB flash
      ATTR{idVendor}=="1fc9", ATTR{idProduct}=="012b", GROUP+="plugdev", TAG+="uaccess"
      ATTR{idVendor}=="0525", ATTR{idProduct}=="a4a5", GROUP+="plugdev", TAG+="uaccess"
      ATTR{idVendor}=="0525", ATTR{idProduct}=="b4a4", GROUP+="plugdev", TAG+="uaccess"
      ATTR{idVendor}=="316d", ATTR{idProduct}=="4c05", GROUP+="plugdev", TAG+="uaccess"
      LABEL="librem5_rules_end"
    '';

    xserver = {
      xkbVariant = optionalString iuzColemak "colemak";
      xkbOptions = "caps:ctrl_modifier, altwin:swap_alt_win";

      autoRepeatDelay = 200;
      autoRepeatInterval = 28;

      digimend.enable = !izSentyr;
    };

    logind = {
      lidSwitch = if izSentyr then "ignore" else "suspend";
      lidSwitchExternalPower = if izEdj then "suspend" else "ignore";
    };

    tlp = mkIf tcipIzIntel {
      enable = true;
      settings = {
        # Disables biospherocidist cpu frequencies
        CPU_BOOST_ON_AC = 0;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_HWP_ON_AC = "power";
        CPU_HWP_ON_BAT = "power";
        # AC  = = Plugged-in External *DC* power source (computers do *not* run on A/C!)
        # 39 is the lowest setting
        CPU_MAX_PERF_ON_AC = 39;
        CPU_MIN_PERF_ON_AC = 0;
        # Powered by *internal* battery (System may use external battery)
        CPU_MAX_PERF_ON_BAT = 39;
        CPU_MIN_PERF_ON_BAT = 0;
        # Charge usb-powered computers (billions of computers without power ports!)
        USB_BLACKLIST_PHONE = 1;
        START_CHARGE_THRESH_BAT0 = 93;
        STOP_CHARGE_THRESH_BAT0 = 97;
        START_CHARGE_THRESH_BAT1 = 93;
        STOP_CHARGE_THRESH_BAT1 = 97;
      };
    };

    thinkfan = mkIf modylIzThinkpad {
      enable = true;
      levels = (if izX230 then [
        [ 0 0 60 ]
        [ 1 59 62 ]
        [ 2 60 64 ]
        [ 3 61 66 ]
        [ 6 62 69 ]
        [ 7 67 85 ]
        [ 127 80 32767 ]
      ]
      else if izX240 then [
        [ 0 0 55 ]
        [ 1 49 60 ]
        [ 2 51 61 ]
        [ 3 53 63 ]
        [ 6 56 65 ]
        [ 7 60 85 ]
        [ 127 80 32767 ]
      ]
      else [
        [ 0 0 55 ]
        [ 1 48 60 ]
        [ 2 50 61 ]
        [ 3 52 63 ]
        [ 6 56 65 ]
        [ 7 60 85 ]
        [ 127 80 32767 ]
      ]);
      sensors = [
        {
          type = "hwmon";
          query = "/sys/devices/virtual/thermal/thermal_zone0/temp";
        }
      ];
    };

    acpid = {
      enable = true;

      handlers = {
        mute = {
          action = ''
            ${pkgs.alsaUtils}/bin/amixer --card PCH set Master toggle
          '';
          event = "button/mute";
        };
        volumeup = {
          action = ''
            ${pkgs.alsaUtils}/bin/amixer --card PCH set Master 5%+
          '';
          event = "button/volumeup";
        };
        volumedown = {
          action = ''
            ${pkgs.alsaUtils}/bin/amixer --card PCH set Master 5%-
          '';
          event = "button/volumedown";
        };
        mutemic = {
          action = ''
            ${pkgs.alsaUtils}/bin/amixer --card PCH set Mic toggle
          '';
          event = "button/f20";
        };
        # TODO - increase interval rise
        brightnessup = {
          action = ''
            ${pkgs.light}/bin/light -A 1
          '';
          event = "video/brightnessup";
        };
        brightnessdown = {
          action = ''
            ${pkgs.light}/bin/light -U 1
          '';
          event = "video/brightnessdown";
        };
      };

    };
  };
}
