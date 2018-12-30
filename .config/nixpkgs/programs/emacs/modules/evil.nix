import ../builder.nix "evil" ({ lib, config, dag, ... }:
with lib; 
let
  cfg = config.evil;
in {
  options ={
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Should we be evil?";
    };
    collection = mkEnableOption "evil-collection";
  };
  config = {
    extraPackages = epkgs: with epkgs; [
      evil
    ] ++ optional (cfg.collection) evil-collection;

    init = {
      evil = ''
        (use-package evil
          ${optionalString cfg.collection ''
          :init
            (setq evil-want-integration t)
            (setq evil-want-keybinding nil)''}
          :config
          (evil-mode 1))
      '';
    } // optionalAttrs cfg.collection {
      "evil-collection" = dag.entryAfter ["evil"] ''
        (use-package evil-collection
          :after evil
          :config
          (evil-collection-init))
      '';
    };
  };
})
