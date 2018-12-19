{ stdenv, lib, fish, fetchFromGitHub }: 

let
  extendedPkgVersion = lib.getVersion fish;
  extendedPkgName = lib.removeSuffix "-${extendedPkgVersion}" fish.name;
  
  buildPlugin = {
    name,
    namePrefix ? "${extendedPkgVersion}-plugin-",
    src,
    buildPhase ? ":",
    buildInputs ? [],
    packages ? []
  }: stdenv.mkDerivation {
    name = namePrefix + name;
    configurePhase = ":";
    dontPatchELF = true;
    dontStrip = true;
    inherit src buildPhase buildInputs packages;
    installPhase = ''
      for d in ./conf.d ./completions ./functions; do
        if [[ -d $d ]]; then
          mkdir -p $out/$d
          mv -t $out/$d/ $d/*.fish
        fi
      done

      for f in ./*.fish; do
        case $f in
          ./{init,key_bindings}.fish)
            mkdir -p $out/conf.d
            mv $f $out/conf.d/$name_''${f##/*}
            ;;
          *)
            mkdir -p $out/functions
            mv -t $out/functions/ $f
        esac
      done
    '';
  };

  pluginFromGitHub = {
    owner, repo, rev, sha256, name ? repo, packages ? []
  }: buildPlugin {
    inherit name packages;
    src = fetchFromGitHub {
      inherit owner repo rev sha256;
    };
  };
in {
  inherit pluginFromGitHub buildPlugin;
}