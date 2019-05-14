with import <nixpkgs> {};
let
  inherit (pkgs) mkShell;
in mkShell {
  buildInputs = with pkgs; [
  (haskellPackages.ghcWithPackages (self: [
    self.taffybar
  ])) ];
}
