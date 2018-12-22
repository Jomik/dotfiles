{ callPackage, ... }:

{
  dotfiles-sh = callPackage ./dotfiles-sh.nix {};
  android = callPackage ./android {};
}
