with import <nixpkgs> {};
let
  inherit (pkgs) mkShell;
in mkShell {
  buildInputs = with pkgs; [
  (haskellPackages.ghcWithPackages (self: [
    self.xmonad
    self.xmonad-contrib
    self.xmonad-extras
    self.taffybar
  ])) ];
}
