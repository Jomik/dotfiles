{ pkgs, stdenv, utils }:

stdenv.mkDerivation {
  name = "${utils.fishName}-plugin-thefuck";
  dependencies = [ pkgs.thefuck ];

  buildCommand = ''
    mkdir -p $out/functions
    HOME=$(mktemp -d) ${pkgs.fish}/bin/fish -c "${pkgs.thefuck}/bin/thefuck --alias > $out/functions/fuck.fish"
    chmod +x $out/functions/fuck.fish
  '';
}
