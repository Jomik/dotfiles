{ pkgs, ... }:

{
  home.packages = with pkgs; [
    taffybar
  ];

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}";
  };
}
