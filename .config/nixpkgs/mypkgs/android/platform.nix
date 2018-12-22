{ lib, pkgs }:
{ apiLevel ? 28, rev ? 6, sha256 ? "1gg752gw1i0mk9i2g9ncycxahyivjhmg1i23namji938jszxnll4" }:

pkgs.stdenv.mkDerivation rec {
  inherit apiLevel rev;
  version = "${toString apiLevel}_r${lib.fixedWidthNumber 2 rev}";
  name = "android-sdk-platform-${version}";
  src = pkgs.fetchurl {
    inherit sha256;
    url = "https://dl-ssl.google.com/android/repository/platform-${version}.zip";
  };
  buildInputs = with pkgs; [ unzip ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    mv -t $out ./*
  '';
}
