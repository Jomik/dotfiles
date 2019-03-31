{ pkgs, config, lib, ... }:

with lib;
let
  inherit (config.lib) dag;
  gruvbox = pkgs.fetchFromGitHub {
    owner = "Briles";
    repo = "gruvbox";
    rev = "f60c67ca6c1d8b2148305f6522e2fb4c24efd250";
    sha256 = "1fk88fyxl90v8yggycf9121nmvwdcp52l25c182j394vdpl1lcp6";
  };
in mkIf config.programs.bat.enable {
  programs.bat.config.theme = "gruvbox";
  xdg.configFile."bat/themes/gruvbox.tmTheme".source = "${gruvbox}/gruvbox (Light) (Medium).tmTheme";
  home.activation.bat-cache = dag.entryAfter ["onFilesChange"]"$DRY_RUN_CMD bat cache --build";
}
