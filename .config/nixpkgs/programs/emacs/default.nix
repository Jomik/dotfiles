{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.programs.emacs;
  dag = config.lib.dag;

  initEntry = types.submodule {
    options = {
      data = mkOption {
        type = types.lines;
        description = "Emacs code to execute";
      };

      before = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "To be done before the given targets";
      };

      after = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "To be done after the given targets";
      };
    };
  };
in {
  imports = map (name: "${./modules}/${name}")
    (builtins.attrNames (builtins.readDir ./modules));

  options.programs.emacs = {
    service = mkEnableOption "Emacs daemon systemd service";

    init = mkOption {
      type = with types; attrsOf (coercedTo str dag.entryAnywhere initEntry);
      default = dag.empty;
      description = "Init entries";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.file.".emacs.d/init.el".text = "(package-initialize)"
        + concatMapStringsSep
          "\n\n"
          ({ name, data }: "; Section ${name}\n${data}")
          (dag.topoSort cfg.init).result;
    }

    (mkIf cfg.service {
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
  })]);
}