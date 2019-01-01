{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.programs.emacs;
in {
  options.programs.emacs.service = mkEnableOption "Emacs daemon systemd service";

  config = mkIf (cfg.enable && cfg.service) {
    systemd.user.services.emacs = {
      Unit = {
        Description = "Emacs: the extensible, self-documenting text editor";
        Documentation = "info:emacs man:emacs(1) https://gnu.org/software/emacs/";
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.stdenv.shell} -l -c 'exec ${cfg.finalPackage}/bin/emacs --fg-daemon'";
        ExecStop = "${cfg.finalPackage}/bin/emacsclient --eval '(kill-emacs)'";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
