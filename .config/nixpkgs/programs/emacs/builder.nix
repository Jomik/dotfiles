name: builder:
args@{ lib, config, pkgs, ... }:
let
  cfg = config.programs.emacs;
  module = builder (args // { config = cfg; dag = config.lib.dag; });
in with lib; {
  options.programs.emacs."${name}" = {
    enable = mkEnableOption name;
  } // module.options;
  config.programs.emacs = mkIf cfg."${name}".enable module.config;
}