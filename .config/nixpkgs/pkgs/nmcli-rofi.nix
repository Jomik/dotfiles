{ stdenv, fetchFromGitHub,  networkmanager, rofi
, wirelesstools, gawk, gnused, makeWrapper, coreutils }:

stdenv.mkDerivation rec {
  version = "unstable-2018-08-17";
  name = "nmcli-rofi-${version}";

  src = fetchFromGitHub {
    owner = "sinetoami";
    repo = "nmcli-rofi";
    rev = "30ec4d36f36e132117044b6debb54675b778f5ba";
    sha256 = "1r4bkrpbjamfnamxa83x1ncc3iawh93m453ldg3zmrkfsihgany5";
  };

  buildInputs = [ makeWrapper ];
  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a $src/nmcli-rofi $out/bin/nmcli-rofi
    chmod a+x $out/bin/nmcli-rofi
    mkdir -p $out/share/doc/nmcli-rofi/
    cp -a $src/config $out/share/doc/nmcli-rofi/config.example
  '';

  wrapperPath = with stdenv.lib; makeBinPath [
    coreutils
    gawk
    gnused
    networkmanager
    rofi
    wirelesstools
  ];

  fixupPhase = ''
    patchShebangs $out/bin
    wrapProgram $out/bin/nmcli-rofi --prefix PATH : "${wrapperPath}"
  '';
}
