{ pkgs, ... }:

let
  unstable = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    rev = "44b02b52ea6a49674f124f50009299f192ed78bb";
    sha256 = "0gmk6w1lnp6kjf26ak8jzj0h2qrnk7bin54gq68w1ky2pdijnc44";
  }) {};
  fork = import /home/jomik/projects/nixos/nixpkgs {};
  fish-plugins = import ./programs/fish/plugins pkgs;
in {
  imports = [ ./programs ];

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

  programs.vscode.enable = true;
  programs.vscode.extensions = with pkgs.vscode-extensions; [
    bbenoist.Nix
  ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "Vim";
      publisher = "vscodevim";
      version = "0.17.0";
      sha256 = "013qsq8ms5yw40wc550p0ilalj1575aj6pqmrczzj04pvfywmf7d";
    }
    {
      name = "fish-vscode";
      publisher = "skyapps";
      version = "0.2.1";
      sha256 = "0y1ivymn81ranmir25zk83kdjpjwcqpnc9r3jwfykjd9x0jib2hl";
    }
  ];
  programs.vscode.userSettings = {
    editor = {
      fontFamily = "Fira Code";
      tabSize = 2;
      fontLigatures = true;
      wordWrap = "bounded";
      wordWrapColumn = 120;
      formatOnSave = true;
      lineNumbers = "off";
    };
  };
  programs.emacs = {
    enable = true;
    service = true;

    theme = {
      enable = true;
      name = "gruvbox";
      variant = "light-soft";
    };
    evil.enable = true;
    evil.collection = true;
  };

  programs.fish = {
    enable = true;
    shellAbbrs = {
      ls = "exa";
      ll = "exa -lha";
      psg = "ps aux | rg -v rg | rg -i -e VSZ -e";
    };
    functions = {
      mkdir.body = "command mkdir -pv $argv";
      ports.body = "command ss -tulanp";
    };
    plugins = with fish-plugins; [
      prompt.spacefish
      thefuck
      # fasd
    ];
  };
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

  programs.git = {
    enable = true;
    userName = "Jonas Holst Damtoft";
    userEmail = "jonasdamtoft@hotmail.com";
    signing.signByDefault = true;
    signing.key = "F135EB6E5796123F11166E40B41F19B1BAD55D37";
    extraConfig = {
      users.email = "Jomik@users.noreply.github.com";
    };
    aliases = {
      unstage = "reset HEAD --";
      discard = "checkout --";
      last = "log -3 HEAD";
      oops = "commit --amend --no-edit";
      ignored = "ls-files --others --i --exclude-standard";
      l = "log --graph --pretty='%Cred%h%Creset - %C(bold blue)<%an>%Creset %s%C(yellow)%d%Creset %Cgreen(%cr)' --abbrev-commit --date=relative";
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

  services.gpg-agent.enable = true;
  services.gpg-agent.enableSshSupport = true;
  services.flameshot.enable = true;

  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
    BROWSER = "${pkgs.firefox}/bin/firefox";
  };

  programs.home-manager.enable = true;
  # programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
  programs.home-manager.path = "$HOME/projects/nixos/home-manager";
  home.stateVersion = "18.09";
}
