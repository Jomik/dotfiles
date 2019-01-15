{ pkgs, ... }:

let
  unstable = import <unstable> {};
  fork = import /home/jomik/projects/nixos/nixpkgs {};
  editor = pkgs.writeScript "editor" ''
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
      inherit (unstable) thefuck direnv alacritty;
    })
  ];

  home.packages = (with pkgs; [
    nodejs-10_x
    docker_compose
    neovim
    firefox
    gnupg
    exa
    ripgrep
    xsel
    okular
    zip unzip
    gist
    discord
    weechat
    slack

    # mypkgs
    dotfiles-sh
  # ]) ++ (with unstable; [
  ]);

  programs.htop = {
    enable = true;
    showProgramPath = false;
  };
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
    VISUAL = "${editor}";
    BROWSER = "${pkgs.firefox}/bin/firefox";
  };

  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
  home.stateVersion = "18.09";
}
