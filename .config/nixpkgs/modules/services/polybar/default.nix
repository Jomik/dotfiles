{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.polybar;

  eitherStrBoolIntList = with types; either str (either bool (either int (listOf str)));

  toPolybarIni = type: generators.toINI {
    mkSectionName = (name: strings.escape [ "[" "]" ] "${type}/${name}");
    mkKeyValue = key: value:
      let
        quoted = v:
          if hasPrefix " " v || hasSuffix " " v
          then ''"${v}"''
          else v;

        value' =
          if isBool value then (if value then "true" else "false")
          else if (isString value && key != "include-file") then quoted value
          else toString value;
      in
        "${key}=${value'}";
  };

  configFile = pkgs.writeText "polybar.conf" ''
    ${toPolybarIni "bar" cfg.config.bars}
    ${toPolybarIni "module" cfg.config.modules}
    ${cfg.extraConfig}
  '';

  bars = attrNames cfg.config.bars;

  script = pkgs.writeShellScriptBin "polybar-start"
    (concatMapStringsSep "\n" (b: "${cfg.package}/bin/polybar --config=${configFile} ${b} &") bars);
in {
  disabledModules = [ <home-manager/modules/services/polybar.nix> ];

  options.services.polybar = {
    enable = mkEnableOption "Polybar status bar";

    package = mkOption {
      type = types.package;
      default = pkgs.polybar;
      defaultText = "pkgs.polybar";
      description = "Polybar package to install.";
      example =  literalExample ''
        pkgs.polybar.override {
          i3GapsSupport = true;
          githubSupport = true;
        }
      '';
    };

    config = {
      bars = mkOption {
        type = types.attrsOf (types.coercedTo
          types.path
          (p: { "section/base" = { include-file = "${p}"; }; })
          (types.attrsOf eitherStrBoolIntList));
        description = ''
          Polybar configuration. Can be either path to a file, or set of attributes
          that will be used to create the final configuration.
        '';
        default = {};
      };
      modules = mkOption {
        type = types.attrsOf (types.coercedTo
          types.path
          (p: { "section/base" = { include-file = "${p}"; }; })
          (types.attrsOf eitherStrBoolIntList));
        description = ''
          Polybar configuration. Can be either path to a file, or set of attributes
          that will be used to create the final configuration.
        '';
        default = {};
      };
    };

    extraConfig = mkOption {
      type = types.lines;
      description = "Additional configuration to add.";
      default = "";
      example = ''
        [module/date]
        type = internal/date
        interval = 5
        date = "%d.%m.%y"
        time = %H:%M
        format-prefix-foreground = \''${colors.foreground-alt}
        label = %time%  %date%
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.polybar = {
      Unit = {
        Description = "Polybar status bar";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "forking";
        ExecStart = "${script}/bin/polybar-start";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
