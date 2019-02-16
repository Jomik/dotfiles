{ pkgs, lib, config, ... }:

with lib;
let
  deps = with pkgs; {
    inherit rofi;
    inherit (scripts) slock;
    rofiPass = rofi-pass;
    powerMenu = scripts.rofi-menu "power-menu" [
      [ "Lock" "${scripts.slock}/bin/slock" false ]
      [ "Shutdown" "systemctl poweroff" true ]
      [ "Reboot" "systemctl reboot" true ]
      [ "Hibernate" "systemctl hibernate" true ]
      [ "Suspend" "systemctl suspend" true ]
      [ "Halt" "systemctl halt" true ]
    ];
  };
in mkIf config.xsession.windowManager.xmonad.enable {
  home.packages = with pkgs; [
    networkmanagerapplet
  ];

  services.screen-locker.enable = true;
  services.screen-locker.lockCmd = "${pkgs.scripts.slock}/bin/slock";

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
    terminal = "${pkgs.alacritty}";
  };

  xdg.configFile."xmonad/lib/Packages.hs".text = ''
      module Packages where
  '' + concatStringsSep "\n" (map
    (n: ''${n} = (++) "${getAttr n deps}/bin/"'')
    (attrNames deps));
}
