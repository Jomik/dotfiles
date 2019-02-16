{ pkgs, lib, config, ... }:

with lib;

let
  unstable = import <unstable> {};

  taffybarPatch = pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/spencerjanssen/dotfiles/master/nixos/taffybar-gi-gdkpixbuf-2.0.18.patch";
    sha256 = "00fczqii26z005dmzmn6zjbi4l7r0p0vsrs5v170sw556aic4vbh";
  };
in mkIf config.services.taffybar.enable {
  home.packages = with pkgs;[
    at-spi2-core
  ];

  nixpkgs.overlays = [
    (self: super: {
      taffybar = (unstable.taffybar.override {
        ghcWithPackages = (unstable.haskellPackages.override {
          overrides = _: super: {
            taffybar = unstable.haskell.lib.appendPatch super.taffybar taffybarPatch;
          };
        }).ghcWithPackages;
      });
    })
  ];

  services.taffybar.package = pkgs.taffybar.override {
    packages = haskellPackages: with haskellPackages; [
      linear
    ];
  };
}