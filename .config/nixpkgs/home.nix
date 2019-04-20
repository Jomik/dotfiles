{ lib, pkgs, ... }:

let
  unstable = import <unstable> { config.allowUnfree = true;};
  fork = import /home/jomik/projects/nixos/nixpkgs {};
  #editor = pkgs.writeScript "editor" ''
  #  #!${pkgs.stdenv.shell}
  #  emacsclient -c "$@"
  #'';
  myNurExpression = import (builtins.fetchTarball "https://gitlab.com/Jomik/nur-expressions/-/archive/master/nur-expressions-master.tar.gz") { inherit pkgs; };
in rec {
  imports = with builtins;
    map (name: ./configurations + "/${name}") (attrNames (readDir ./configurations))
    ++ map (name: ./modules/programs + "/${name}") (attrNames (readDir ./modules/programs))
    ++ map (name: ./modules/services + "/${name}") (attrNames (readDir ./modules/services))
    ++ (with myNurExpression.home-modules; [ fish ]);

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      nur.repos.jomik = myNurExpression.pkgs;
    })
  ];

  home.packages = (with pkgs; [
    firefox
    gnupg
    xsel
    okular
    zip unzip
    gist
    weechat
    slack
    pass
    gimp
    libreoffice-fresh

    ripgrep
    exa
    fd

    # fonts
    fira fira-code
    source-sans-pro source-code-pro
    font-awesome_5
  ]) ++ (with pkgs.nur.repos.jomik; [
    dotfiles-sh
  ]) ++ (with unstable.pkgs; [
    discord
  ]);

  programs.htop = {
    enable = true;
    showProgramPath = false;
  };
  programs.direnv.enable = true;
  programs.emacs.enable = true;
  services.emacs.enable = true;
  programs.neovim.enable = true;
  programs.fish.enable = true;
  # programs.zsh.enable = true;
  programs.vscode.enable = true;
  programs.git.enable = true;
  programs.bat.enable = true;

  programs.kitty.enable = true;

  programs.alacritty = {
    # enable = true;
    settings = {
      font.size = 6.0;
      colors = {
        primary = {
          background = "0xfbf1c7";
          foreground = "0x3c3836";
        };
        normal = {
          black = "0xfbf1c7";
          red = "0xcc241d";
          green = "0x98971a";
          yellow = "0xd79921";
          blue = "0x458588";
          magenta = "0xb16286";
          cyan = "0x689d6a";
          white = "0x7c6f64";
        };
        bright = {
          black = "0x928374";
          red = "0x9d0006";
          green = "0x79740e";
          yellow = "0xb57614";
          blue = "0x076678";
          magenta = "0x8f3f71";
          cyan = "0x427b58";
          white = "0x3c3836";
        };
      };
      window.dimensions = {
        columns = 120;
        lines = 36;
      };
    };
  };

  programs.texlive.enable = true;
  programs.texlive.extraPackages = tpkgs: {
    inherit (tpkgs)
      scheme-small
      cm-super
      algorithms
      tikz-cd
      csquotes
      braket
      turnstile
      dashbox
      chktex
      cleveref
      bussproofs
      latexmk;
  };

  services.xbanish.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.enableSshSupport = true;
  services.flameshot.enable = true;
  services.random-background = {
    enable = true;
    imageDirectory = "%h/wallpapers/";
  };

  xsession.enable = true;
  systemd.user.startServices = true;
  # xsession.windowManager.xmonad.enable = true;
  # xsession.windowManager.awesome.enable = true;
  xsession.windowManager.i3.enable = true;
  # services.taffybar.enable = true;
  # services.polybar.enable = true;

  # Execute setxkbmap so that rofi-pass can input properly.
  systemd.user.services.setxkbmap.Service.ExecStart = lib.mkForce "${pkgs.xorg.setxkbmap}/bin/setxkbmap";
  # home.keyboard = {
  #   layout = "us";
  #   variant = "colemak";
  #   options = ["ctrl:nocaps"];
  # };

  home.sessionVariables = {
    EDITOR = "nvim";
    # VISUAL = "${editor}";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  programs.home-manager.enable = true;
  # programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
  home.stateVersion = "18.09";
}
