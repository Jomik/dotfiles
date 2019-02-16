{ pkgs, ... }:

let
  unstable = import <unstable> { config.allowUnfree = true;};
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
      inherit (unstable) thefuck direnv alacritty fish;
    })
  ];

  home.packages = (with pkgs; [
    neovim
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

    exa
    bat
    ripgrep

    # mypkgs
    dotfiles-sh
  ]) ++ (with unstable; [
    discord
  ]);

  programs.htop = {
    enable = true;
    showProgramPath = false;
  };
  programs.fzf.enable = true;
  programs.direnv.enable = true;
  programs.emacs.enable = true;
  services.emacs.enable = true;
  programs.fish.enable = true;
  # programs.zsh.enable = true;
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
  services.random-background = {
    enable = true;
    imageDirectory = "%h/wallpapers/";
  };

  xsession.enable = true;
  systemd.user.startServices = true;
  # Disable setxkbmap hack
  systemd.user.services.setxkbmap.Service.ExecStart = "${pkgs.xorg.setxkbmap}/bin/setxkbmap";
  xsession.windowManager.xmonad.enable = true;
  services.taffybar.enable = true;

  home.sessionVariables = {
    EDITOR = "${editor}";
    VISUAL = "${editor}";
    BROWSER = "${pkgs.firefox}/bin/firefox";
  };

  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
  home.stateVersion = "18.09";
}
