import ../builder.nix "theme" ({ lib, pkgs, config, ... }:
with lib; 
let
  themeNames = map (removeSuffix "-theme") (filter (hasSuffix "-theme") (attrNames pkgs.emacsPackagesNg));
  cfg = config.theme;
in {
  options = {
    name = mkOption {
      type = types.enum themeNames;
      description = "Which theme to load.";
    };
    variant = mkOption {
      type = types.nullOr types.string;
      default = null;
      description = "Theme variant to use, will append the variant to the theme name, separated by a dash.";
    };
  };

  config = {
    extraPackages = epkgs: [
      epkgs."${cfg.name}-theme"
    ];

    init = {
      theme = ''
        (use-package ${cfg.name}-theme
          :config
          (load-theme '${cfg.name}${optionalString (cfg.variant != null) "-${cfg.variant}"} t))
      '';
    };
  };
})
