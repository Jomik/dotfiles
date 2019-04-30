{ pkgs, lib, config, ... }:

with lib;
let
  deps = with pkgs; with nur.repos.jomik; {
    inherit rofi;
    jomikI3lock = jomikI3lock;
    rofiPass = rofi-pass;
    powerMenu = rofi-menu "power-menu" [
      [ "Lock" "${jomik-i3lock}/bin/jomik-i3lock" false ]
      [ "Suspend" "systemctl suspend" true ]
      [ "Hibernate" "systemctl hibernate" true ]
      [ "Reboot" "systemctl reboot" true ]
      [ "Shutdown" "systemctl poweroff" true ]
      [ "Halt" "systemctl halt" true ]
    ];
  };
in mkIf config.xsession.windowManager.xmonad.enable {
  home.packages = with pkgs; [
    networkmanagerapplet
  ];

  services.screen-locker.enable = true;
  services.screen-locker.lockCmd = "${pkgs.nur.repos.jomik.jomik-i3lock}/bin/jomik-i3lock";
  services.dunst.enable = true;

  xsession = {
    windowManager.xmonad = {
      enableContribAndExtras = true;
    };
    pointerCursor = {
      defaultCursor = "left_ptr";
      package = pkgs.gnome3.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
  };

  programs.rofi = {
    enable = true;
    terminal = "$TERMINAL";
    separator = "solid";
    theme = "gruvbox-dark-soft";
    extraConfig = ''
      rofi.modi: drun,window
    '';
  };

  xdg.configFile."xmonad/lib/Packages.hs".text = ''
      module Packages where
  '' + concatStringsSep "\n" (map
    (n: ''${n} = (++) "${getAttr n deps}/bin/"'')
    (attrNames deps));
}
