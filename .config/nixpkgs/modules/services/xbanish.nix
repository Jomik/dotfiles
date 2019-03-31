{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xbanish;
in {
  options.services.xbanish = {
    enable = mkEnableOption "xbanish";

    package = mkOption {
      type = types.package;
      default = pkgs.xbanish;
      defaultText = "pkgs.xbanish";
      description = "xbanish package to use";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.xbanish = {
      Unit = {
        Description = "Xbanish";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/xbanish";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
