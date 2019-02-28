{ pkgs, lib, config, ... }:

with lib;
let
in mkIf config.services.dunst.enable {
  services.dunst.settings = {
    global = {
      dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst";
      format = "<b>%s</b>\\n%b";
      frame_width = 1;
      frame_color = "#383838";
      alignment = "center";
      geometry = "200x5-10+50";
      line_height = 0;
      separator_height = 2;
      padding = 8;
      horizontal_padding = 8;
      separator_color = "#585858";
      word_wrap = true;
      show_indicators = false;
    };

    urgency_low = {
      background = "#181818";
      foreground = "#E3C7AF";
    };
    urgency_normal = {
      background = "#181818";
      foreground = "#E3C7AF";
    };
    urgency_critical = {
      background = "#181818";
      foreground = "#E3C7AF";
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin "dunst-test" ''
      export PATH=${makeBinPath [ pkgs.libnotify ]}
      notify-send -u critical "Test message: critical test 1"
      notify-send -u normal "Test message: normal test 2"
      notify-send -u low "Test message: low test 3"
      notify-send -u critical "Test message: critical test 4"
      notify-send -u normal "Test message: normal test 5"
      notify-send -u low "Test message: low test 6"
      notify-send -u critical "Test message: critical test 7"
      notify-send -u normal "Test message: normal test 8"
      notify-send -u low "Test message: low test 9"
    '')
  ];
}
