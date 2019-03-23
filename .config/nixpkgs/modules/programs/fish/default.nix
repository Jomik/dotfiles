{ config, lib, pkgs,... }:

with lib;
let
  types = lib.types // import ../../lib/types.nix { inherit lib; };
  utils = pkgs.callPackage ./fish-utils.nix {};
  cfg = config.programs.fish;

  fileType = types.submodule (
    { name, config, ... }: {
      options = {
        body = mkOption {
          default = null;
          type = types.nullOr types.lines;
          description = "Body of the function.";
        };

        source = mkOption {
          type = types.path;
          description = ''
            Path of the source file. The file name must not start
            with a period.
          '';
        };
      };

      config = {
        source = mkIf (config.body != null) (
          mkDefault (pkgs.writeTextFile {
            inherit name;
            text = ''
            function ${name}
              ${config.body}
            end
            '';
            executable = true;
          })
        );
      };
    }
  );
in {
  options = {
    programs.fish.plugins = mkOption {
      type = types.selectorFunction;
      default = plugins: [];
      description = ''
        The plugins to add to fish.
        Built with <varname>buildFishPlugin</varname> or fetched from GitHub with <varname>buildFishPluginFromGitHub</varname>.
        Overrides manually installed ones.
      '';
    };
    programs.fish.functions = mkOption {
      type = types.attrsOf fileType;
      default = {};
      description = ''
        Functions to add to fish.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      xdg.configFile = map (n: { target = "fish/functions/${n}.fish"; source = cfg.functions.${n}.source; }) (attrNames cfg.functions);
    } (
    let
    plugins = cfg.plugins (import ./plugins { inherit pkgs utils; });
      wrappedPkgVersion = lib.getVersion pkgs.fish;
      wrappedPkgName = lib.removeSuffix "-${wrappedPkgVersion}" pkgs.fish.name;
      dependencies = concatMap (p: p.dependencies) plugins;
      combinedPluginDrv = pkgs.buildEnv {
        name = "${wrappedPkgName}-plugins-${wrappedPkgVersion}";
        paths = plugins;
        postBuild = ''
          touch $out/setup.fish
          if [ -d $out/functions ]; then
            echo "set -x fish_function_path $out/functions \$fish_function_path" >> $out/setup.fish
          fi

          if [ -d $out/completions ]; then
            echo "set -x fish_complete_path $out/completions \$fish_complete_path" >> $out/setup.fish
          fi

          if [ -d $out/conf.d ]; then
            echo "source $out/conf.d/*.fish" >> $out/setup.fish
          fi
        '';
      };
    in mkIf (length plugins > 0) {
      xdg.configFile."fish/conf.d/00plugins.fish".source = "${combinedPluginDrv}/setup.fish";
      home.packages = dependencies;
    })]);
}
