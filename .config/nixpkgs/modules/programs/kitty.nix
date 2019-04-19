{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.kitty;

  configFile = pkgs.writeTextDir "kitty.conf"
    (with generators; toKeyValue { mkKeyValue = mkKeyValueDefault {} " "; } cfg.settings);

  pkg = cfg.package.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper ];

    postFixup = ''
      wrapProgram "$out/bin/.kitty-wrapped" \
        --set KITTY_CONFIG_DIRECTORY "${configFile}"
    '';
  });
in
{
  options = {
    programs.kitty = {
      enable = mkEnableOption "Kitty";

      settings = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          Kitty settings.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.kitty;
        description = ''
          The kitty package to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkg ];
  };
}
