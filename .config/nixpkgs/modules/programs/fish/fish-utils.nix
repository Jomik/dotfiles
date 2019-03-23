{ stdenv, lib, fish, fetchFromGitHub }:

let
  fishVersion = lib.getVersion fish;
  fishName = lib.removeSuffix "-${fishVersion}" fish.name;

  buildFishPlugin = {
    name,
    namePrefix ? "${fishName}-plugin-",
    src,
    buildPhase ? ":",
    buildInputs ? [],
    dependencies ? []
  }: stdenv.mkDerivation {
    name = namePrefix + name;
    configurePhase = ":";
    dontPatchELF = true;
    dontStrip = true;
    inherit src buildPhase buildInputs dependencies;
    installPhase = ''
      for dir in ./conf.d ./completions ./functions; do
        if [[ -d $dir ]]; then
          mkdir -p $out/$dir
          mv -t $out/$dir/ $dir/*.fish
        fi
      done

      for file in ./*.fish; do
        case $file in
          ./{init,key_bindings}.fish)
            mkdir -p $out/conf.d
            mv $file $out/conf.d/$name_''${file##/*}
            ;;
          *)
            mkdir -p $out/functions
            mv -t $out/functions/ $file
        esac
      done
    '';
  };

  buildFishPluginFromGitHub = {
    owner, repo, rev, sha256, name ? repo, dependencies ? []
  }: buildFishPlugin {
    inherit name dependencies;
    src = fetchFromGitHub {
      inherit owner repo rev sha256;
    };
  };
in {
  inherit fishVersion fishName buildFishPluginFromGitHub buildFishPlugin;
}
