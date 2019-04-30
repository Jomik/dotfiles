{ lib, pkgs, ... }:

let
  unstable = import <unstable> { config.allowUnfree = true;};
  fork = import /home/jomik/projects/nixos/nixpkgs {};
  #editor = pkgs.writeScript "editor" ''
  #  #!${pkgs.stdenv.shell}
  #  emacsclient -c "$@"
  #'';
  myNurExpressions = import <nur-jomik> { inherit pkgs; };
  # myNurExpressions = import ~/projects/nix/nur-expressions { inherit pkgs; };
in rec {
  imports = with builtins;
    map (name: ./configurations + "/${name}") (attrNames (readDir ./configurations))
    ++ map (name: ./modules/programs + "/${name}") (attrNames (readDir ./modules/programs))
    ++ map (name: ./modules/services + "/${name}") (attrNames (readDir ./modules/services))
    ++ (with myNurExpressions.home-modules; [ fish ]);

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      nur.repos.jomik = myNurExpressions.pkgs;
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
