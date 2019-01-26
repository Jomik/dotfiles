{ pkgs, lib, ... }:

with lib;
let
  deps = with pkgs; {
    taffybar = taffybar;
    rofi = rofi;
    rofiPass = rofi-pass;
  };
in
{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}";
  };

  xdg.configFile."xmonad/lib/Packages.hs".text = ''
    module Packages where
  '' + concatStringsSep "\n" (map
    (n: ''${n} = (++) "${getAttr n deps}"'')
    (attrNames deps));
}
