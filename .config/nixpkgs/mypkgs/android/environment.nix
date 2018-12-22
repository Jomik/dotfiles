{ lib, pkgs }:
{ tools, platform-tools, build-tools, platforms }:

pkgs.runCommand "android-environment" { preferLocalBuild = true; } ''
  mkdir -p $out
  ln -s ${tools}/* $out/
  ln -s ${platform-tools} $out/platform-tools
  mkdir -p $out/build-tools
  ln -s ${build-tools} $out/build-tools/${build-tools.version}
  mkdir -p $out/platforms
  ${lib.concatMapStrings (p: ''
    ln -s ${p} $out/platforms/android-${toString p.apiLevel}
  '') platforms}
  yes | $out/bin/sdkmanager --sdk_root=$out --licenses > /dev/null
''