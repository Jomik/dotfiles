{ pkgs, config, lib, ... }:

let
  fish-plugins = import ../modules/programs/fish/plugins pkgs;
in {
  imports = [ ../modules/programs/fish ];

  home.file.".bashrc" = lib.mkIf config.programs.fish.enable {
    text = ''
        exec ${config.programs.fish.package}/bin/fish
    '';
  };

  programs.fish = {
    shellAbbrs = {
      ls = "exa";
      ll = "exa -lha";
      psg = "ps aux | rg -v rg | rg -i -e VSZ -e";
      e = "emacsclient -nc";
      E = "sudoedit";
      grep = "rg";
      cat = "bat";
    };
    functions = {
      mkdir.body = "command mkdir -pv $argv";
      ports.body = "command ss -tulanp";
    };
    plugins = with fish-plugins; [
      prompt.spacefish
      thefuck
    ];
  };
}
