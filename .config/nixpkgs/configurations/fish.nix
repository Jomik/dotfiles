{ pkgs, ... }:

let 
  fish-plugins = import ../modules/programs/fish/plugins pkgs;
in {
  imports = [ ../modules/programs/fish ];
  programs.fish = {
    shellAbbrs = {
      ls = "exa";
      ll = "exa -lha";
      psg = "ps aux | rg -v rg | rg -i -e VSZ -e";
      ec = "emacsclient -nc";
      grep = "rg";
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
