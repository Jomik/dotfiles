{ pkgs, ... }:

let
  unstable = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    rev = "61c3169a0e17d789c566d5b241bfe309ce4a6275";
    sha256 = "0qbycg7wkb71v20rchlkafrjfpbk2fnlvvbh3ai9pyfisci5wxvq";
  }) { config.allowUnfree = true ;};
  mypkgs = import ./mypkgs pkgs;
  fish-plugins = import ./programs/fish/plugins pkgs;
in {
  imports = [ ./programs/alacritty.nix ./programs/fish/fish.nix ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (self: super: {
      vscode-with-extensions = unstable.vscode-with-extensions;
    })
  ];

  home.packages =
    (with pkgs; [
      neovim firefox gnupg exa ripgrep xclip okular weechat zip unzip
    ]) ++ (with unstable; [
      atom
    ]) ++ (with mypkgs; [
      dotfiles-sh
    ]);

  programs.htop.enable = true;
  programs.fzf.enable = true;
  programs.direnv.enable = true;

  programs.vscode.enable = true;
  programs.vscode.extensions = with pkgs.vscode-extensions; [ bbenoist.Nix ];
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

  programs.fish = {
    enable = true;
    shellAbbrs = {
      ls = "exa";
      ll = "exa -lha";
      mkdir = "mkdir -pv";
      ports = "netstat -tulanp";
      psg = "ps aux | rg -v rg | rg -i -e VSZ -e";
    };
    plugins = with fish-plugins; [
      prompt.spacefish fasd
    ];
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

  programs.alacritty.enable = true;
  programs.alacritty.font.size = 6.0;
  programs.alacritty.window.dimensions = {
    columns = 120;
    lines = 36;
  };

  services.gpg-agent.enable = true;
  services.gpg-agent.enableSshSupport = true;
  services.flameshot.enable = true;

  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
    BROWSER = "${pkgs.firefox}/bin/firefox";
  };

  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
  home.stateVersion = "18.09";
}
