{ pkgs, ... }:

let
  unstable = import <unstable> { config.allowUnfree = true;};
  fork = import /home/jomik/projects/nixos/nixpkgs {};
  #editor = pkgs.writeScript "editor" ''
  #  #!${pkgs.stdenv.shell}
  #  emacsclient -c "$@"
  #'';
in rec {
  imports = [
    ./modules/programs/alacritty.nix
    ./modules/services/polybar.nix
    ./modules/services/xbanish.nix
  ] ++ map (name: ./configurations + "/${name}")
    (builtins.attrNames (builtins.readDir ./configurations));

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      nur.repos.jomik = import "${builtins.fetchTarball "https://gitlab.com/Jomik/nur-expressions/-/archive/master/nur-expressions-master.tar.gz"}/overlay.nix" self super;
    })
    (self: super: {
      neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldattrs: {
        version = "0.4.0";
        src = pkgs.fetchFromGitHub {
          owner = "neovim";
          repo = "neovim";
          rev = "36762a00a8010c5e14ad4347ab8287d1e8e7e064";
          sha256 = "0n7i3mp3wpl8jkm5z0ifhaha6ljsskd32vcr2wksjznsmfgvm6p4";
        };
      });
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

    # fonts
    fira fira-code
    source-sans-pro source-code-pro
    font-awesome_5
  ]) ++ (with pkgs.nur.repos.jomik; [
    dotfiles-sh
    csd-post # For openconnect
  ]) ++ (with unstable.pkgs; [
    discord
    openconnect
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

  programs.alacritty = {
    enable = true;
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
  # Disable setxkbmap hack
  systemd.user.services.setxkbmap.Service.ExecStart = "${pkgs.xorg.setxkbmap}/bin/setxkbmap";
  # xsession.windowManager.xmonad.enable = true;
  # xsession.windowManager.awesome.enable = true;
  xsession.windowManager.i3.enable = true;
  # services.taffybar.enable = true;
  # services.polybar.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    # VISUAL = "${editor}";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  programs.home-manager.enable = true;
  # programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
  home.stateVersion = "18.09";
}
