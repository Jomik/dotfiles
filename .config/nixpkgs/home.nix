{ pkgs, ... }:

let
  unstable = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    rev = "44b02b52ea6a49674f124f50009299f192ed78bb";
    sha256 = "0gmk6w1lnp6kjf26ak8jzj0h2qrnk7bin54gq68w1ky2pdijnc44";
  }) {};
  fork = import /home/jomik/projects/nixos/nixpkgs {};

  editor = pkgs.writeScript "editor" ''
    #!${pkgs.stdenv.shell}
    emacsclient -t "$@"
  '';

  visual = pkgs.writeScript "visual" ''
    #!${pkgs.stdenv.shell}
    emacsclient -c "$@"
  '';

in rec {
  imports = [
    ./modules/programs/alacritty
  ] ++ map (name: ./configurations + "/${name}")
    (builtins.attrNames (builtins.readDir ./configurations));

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (import ./overlays/pkgs.nix)
    (self: super: {
      inherit (unstable) thefuck;
      inherit (fork) alacritty;
    })
  ];

  home.packages = (with pkgs; [
    neovim
    firefox
    gnupg
    exa
    ripgrep
    xsel
    okular
    weechat
    zip unzip
    atom
    discord
    gist

    # mypkgs
    dotfiles-sh
  # ]) ++ (with unstable; [
  ]);

  programs.htop.enable = true;
  programs.fzf.enable = true;
  programs.direnv.enable = true;
  programs.emacs.enable = true;
  programs.emacs.service = true;
  programs.fish.enable = true;
  programs.vscode.enable = true;
  programs.git.enable = true;

  programs.alacritty = {
    enable = true;
    font.size = 6.0;
    colors.primary.background = "0x191919";
    window.dimensions = {
      columns = 120;
      lines = 36;
    };
  };
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      copycat
      yank
      open
    ];
    extraConfig = ''
      set -g mode-keys "vi"
    '';
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

  services.gpg-agent.enable = true;
  services.gpg-agent.enableSshSupport = true;
  services.flameshot.enable = true;

  home.sessionVariables = {
    EDITOR = "${editor}";
    VISUAL = "${visual}";
    BROWSER = "${pkgs.firefox}/bin/firefox";
  };

  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
  home.stateVersion = "18.09";
}
