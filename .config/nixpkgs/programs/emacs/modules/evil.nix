{ config, lib, pkgs, ... }:

with lib; 
let
  cfg = config.programs.emacs;
in {
  options.programs.emacs = {
    evil = mkOption {
      type = types.bool;
      default = false;
      description = "Should we be evil?";
    };
    leader = mkOption {
      type = types.string;
      default = "/";
    };
  };

  config.programs.emacs = mkIf cfg.evil {
    extraPackages = epkgs: with epkgs; [
      evil
      evil-leader
      evil-collection
    ];

    init = {
      evil = ''
        (setq evil-want-integration nil)
        (evil-collection-init)
        (setq evil-collection-setup-minibuffer t)
        (global-evil-leader-mode)
        (evil-mode 1)
        (evil-leader/set-leader "${cfg.leader}")
        (setq evil-leader/in-all-states t)
      '';
    };
  };
}