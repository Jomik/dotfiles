{ pkgs, lib, config, ... }:

with lib;

mkIf config.services.taffybar.enable {
  services.taffybar.package = pkgs.taffybar.override {
    packages = haskellPackages: with haskellPackages; [
      linear
    ];
  };
}
