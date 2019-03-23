{ config, pkgs, lib, ... }:

with lib;

let
  modifier = xsession.windowManager.i3.config.modifier;
  powerMenu = with pkgs; pkgs.scripts.rofi-menu "power-menu" [
    [ "Lock" "${scripts.slock}/bin/slock" false ]
    [ "Logout" "exec i3-msg exit" true ]
    [ "Suspend" "systemctl suspend" true ]
    [ "Hibernate" "systemctl hibernate" true ]
    [ "Reboot" "systemctl reboot" true ]
    [ "Shutdown" "systemctl poweroff" true ]
    [ "Halt" "systemctl halt" true ]
  ];
in mkIf config.xsession.windowManager.i3.enable {
  home.packages = with pkgs; [
    iosevka
  ];
  xsession.windowManager.i3.config = {
    bars = [];
    fonts = [ "Iosevka" ];
    keybindings = mkOptionDefault {
      "${modifier}+Shift+q" = "exec ${powerMenu}/bin/power-menu";
      "${modifier}+Shift+p" = "exec ${pkgs.rofi-pass}/bin/rofi-pass";
      "${modifier}+Shift+l" = "exec ${pkgs.scripts.slock}/bin/slock";
      "${modifier}+p" = "exec ${pkgs.rofi}/bin/rofi -show drun -show-icons";
      "${modifier}+Shift+c" = "kill";
    };
  };

  xsession.pointerCursor = {
    pointerCursor = {
      defaultCursor = "left_ptr";
      package = pkgs.gnome3.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
  };

  services.screen-locker.enable = true;
  services.screen-locker.lockCmd = "${pkgs.scripts.slock}/bin/slock";
  services.dunst.enable = true;

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    separator = "solid";
    theme = "gruvbox-dark-soft";
    extraConfig = ''
      rofi.modi: drun,window
    '';
  };
}
