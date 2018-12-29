{ config, lib, pkgs, ... }:

with lib; 
let
  cfg = config.programs.emacs;
  themeNames = map (removeSuffix "-theme") (filter (hasSuffix "-theme") (attrNames pkgs.emacsPackagesNg));
in {
  options.programs.emacs.theme = mkOption {
    type = types.nullOr (types.enum themeNames);
    default = null;
    description = "Which theme to load.";
  };

  config.programs.emacs = mkIf (cfg.theme != null) {
    extraPackages = epkgs: [
      epkgs."${cfg.theme}-theme"
    ];

    init = {
      theme = "(load-theme '${cfg.theme} t)";
    };
  };
}