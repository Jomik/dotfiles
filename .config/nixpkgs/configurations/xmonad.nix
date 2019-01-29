{ pkgs, lib, config, ... }:

with lib;
let
  unstable = import <unstable> {};
  taffybarPatch = pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/spencerjanssen/dotfiles/master/nixos/taffybar-gi-gdkpixbuf-2.0.18.patch";
    sha256 = "00fczqii26z005dmzmn6zjbi4l7r0p0vsrs5v170sw556aic4vbh";
  };
  deps = with pkgs; {
    inherit rofi;
    rofiPass = rofi-pass;
  };

  cfg = {
    home.packages = [ pkgs.at-spi2-core ];
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
    services.taffybar.enable = true;
    services.taffybar.package = pkgs.taffybar.override {
      packages = haskellPackages: with haskellPackages; [
        linear
      ];
    };
    services.status-notifier-watcher.enable = true;
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
        (n: ''${n} = (++) "${getAttr n deps}"'')
        (attrNames deps));
  };
in lib.mkIf config.xsession.windowManager.xmonad.enable cfg
