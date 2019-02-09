{ lib, pkgs }: { platforms, buildTools }:

with pkgs.androidsdk;

let
  licenses = {
    android-sdk-license = "d56f5187479451eabf01fb78af6dfcb131a6481e";
  };
in pkgs.buildEnv {
  name = "android-sdk-environment";
  paths =  [ tools platformTools ]
    ++ (map (p: builtins.getAttr "platform${toString p}" pkgs.androidsdk) platforms)
    ++ (map (bt: builtins.getAttr "buildTools${toString bt}" pkgs.androidsdk) buildTools);

  postBuild = ''
    mkdir -p $out/licenses
    ${lib.concatMapStrings (a: ''
      echo ${licenses.${a}} > $out/licenses/${a}
    '') (lib.attrNames licenses)}
  '';
}
