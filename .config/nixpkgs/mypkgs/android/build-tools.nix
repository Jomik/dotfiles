{ lib, pkgs, pkgsi686Linux }:

let
  inherit (pkgs) stdenv;
  stdenv_32bit = pkgsi686Linux.stdenv;
  zlib_32bit = pkgsi686Linux.zlib;
  ncurses_32bit = pkgsi686Linux.ncurses5;
in stdenv.mkDerivation rec {
  version = "28.0.3";
  name = "android-sdk-build-tools-r${version}";
  src = pkgs.fetchurl {
    url = "https://dl.google.com/android/repository/build-tools_r${version}-linux.zip";
    sha256 = "16klhw9yk8znvbgvg967km4y5sb87z1cnf6njgv8hg3381m9am3r";
  };
  buildInputs = with pkgs; [ unzip ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    mv -t $out ./*
  '';

  preFixup = ''
    for f in $(grep -Rl /bin/ls $out); do
      sed -i -e "s|/bin/ls|${pkgs.coreutils}/bin/ls|" "$f"
    done

    for file in aapt aapt2 aidl zipalign split-select llvm-rs-cc bcc_compat dexdump x86_64-linux-android-ld; do
      patchelf \
        --set-interpreter "${stdenv.cc.libc.out}/lib/ld-linux-x86-64.so.2" \
        --set-rpath ${stdenv.cc.cc.lib.out}/lib:${pkgs.zlib.out}/lib:${pkgs.ncurses5.out}/lib:$out/lib64 \
          $out/$file
    done

    for file in aarch64-linux-android-ld arm-linux-androideabi-ld i686-linux-android-ld mipsel-linux-android-ld; do
      patchelf \
        --set-interpreter "${stdenv_32bit.cc.libc.out}/lib/ld-linux.so.2" \
        --set-rpath ${stdenv_32bit.cc.cc.lib.out}/lib:${zlib_32bit.out}/lib:${ncurses_32bit.out}/lib:$out/lib \
          $out/$file
    done
  '';
}
