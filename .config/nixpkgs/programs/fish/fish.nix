{ config, lib, pkgs,... }:

with lib;
let
  cfg = config.programs.fish;
in {
  options = {
    programs.fish.plugins = mkOption {
      type = types.listOf types.package;
      default = [];
      description = ''
        The plugins to add to fish.
        Built with <varname>buildPlugin</varname> or fetched from GitHub with <varname>pluginFromGitHub</varname>.
        Overrides manually installed ones.
      '';
    };
  };

  config = mkIf cfg.enable (
    let
      wrappedPkgVersion = lib.getVersion pkgs.fish;
      wrappedPkgName = lib.removeSuffix "-${wrappedPkgVersion}" pkgs.fish.name;
      packages = concatMap (p: p.packages) cfg.plugins;
      combinedPluginDrv = pkgs.buildEnv {
        name = "${wrappedPkgName}-plugins-${wrappedPkgVersion}";
        paths = cfg.plugins;
      };
    in {
      xdg.configFile."fish/conf.d/00plugins.fish".text = ''
        set -x fish_function_path ${combinedPluginDrv}/functions $fish_function_path
        set -x fish_complete_path ${combinedPluginDrv}/completions $fish_complete_path
        source ${combinedPluginDrv}/conf.d/*.fish
      '';
      home.packages = packages;
    });
}
