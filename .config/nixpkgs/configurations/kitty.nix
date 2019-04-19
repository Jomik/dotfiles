{ config, lib, pkgs, ... }:

with lib;

let
  gruvbox-light = {
    bg = "#fbf1c7";
    bg1 = "#ebdbb2";
    bg2 = "#d5c4a1";
    bg3 = "#bdae93";
    bg4 = "#a89984";
    fg = "#282828";
    fg1 = "#3c3836";
    fg2 = "#504945";
    fg3 = "#665c54";
    fg4 = "#7c6f64";
    gray = "#928374";
    red = "#cc241d";
    red-dim = "#9d0006";
    green = "#98971a";
    green-dim = "#79740e";
    yellow = "#d79921";
    yellow-dim = "#b57614";
    blue = "#458588";
    blue-dim = "#076678";
    purple = "#b16286";
    purple-dim = "#8f3f71";
    aqua = "#689d6a";
    aqua-dim = "#427b58";
    orange = "#d65d0e";
    orange-dim = "#af3a03";
  };
in mkIf config.programs.kitty.enable {
  programs.kitty.settings = with gruvbox-light; {
    font_family = "Fira Code Retina";

    # Color scheme
    foreground = fg;
    background = bg;

    selection_foreground = bg2;
    selection_background = fg;

    cursor = fg2;
    cursor_text_color = "background";
    cursor_blink_interval = 0;
    scrollback_lines = 10000;

    # Black
    color0 = bg;
    color8 = gray;
    # Red
    color1 = red-dim;
    color9 = red;
    # Green
    color2 = green-dim;
    color10 = green;
    # Yellow
    color3 = yellow-dim;
    color11 = yellow;
    # Blue
    color4 = blue-dim;
    color12 = blue;
    # Magenta
    color5 = purple-dim;
    color13 = purple;
    # Cyan
    color6 = aqua-dim;
    color14 = aqua;
    # White 
    color7 = fg;
    color15 = fg;
  };
}

