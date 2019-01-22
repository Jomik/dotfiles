{ pkgs, config, ... }:

let
  fish-plugins = import ../modules/programs/fish/plugins pkgs;
in {
  imports = [ ../modules/programs/fish ];

  home.file.".bashrc".text = ''
    exec ${config.programs.fish.package}/bin/fish
  '';

  programs.fish = {
    shellAbbrs = {
      ls = "exa";
      ll = "exa -lha";
      psg = "ps aux | rg -v rg | rg -i -e VSZ -e";
      e = "emacsclient -nc";
      grep = "rg";
    };
    functions = {
      E.body = ''
        set -lx SUDO_EDITOR emacsclient -c
        command sudoedit $argv
      '';
      mkdir.body = "command mkdir -pv $argv";
      ports.body = "command ss -tulanp";
    };
    plugins = with fish-plugins; [
      prompt.spacefish
      thefuck
    ];
  };
}
