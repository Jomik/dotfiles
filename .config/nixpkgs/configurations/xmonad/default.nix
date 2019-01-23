{ pkgs, ... }:

let
  deps = [
  ];
in
{
  home.packages = with pkgs; [
    rofi-pass
  ];
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}";
  };
}
