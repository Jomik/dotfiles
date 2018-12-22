self: super:

{
  dotfiles-sh = super.callPackage ../mypkgs/dotfiles-sh.nix {};
  androidsdk = super.callPackage ../mypkgs/androidsdk {};
}
