{ callPackage, ... }:

{
  build-tools = callPackage ./build-tools.nix {};
  platform-tools = callPackage ./platform-tools.nix {};
  tools = callPackage ./tools.nix {};
  platform = callPackage ./platform.nix {};
  environment = callPackage ./environment.nix {};
}