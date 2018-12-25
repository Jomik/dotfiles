self: super:

{
  dotfiles-sh = super.callPackage ../pkgs/dotfiles-sh.nix {};
  androidsdk = super.callPackage ../pkgs/androidsdk {};
}
