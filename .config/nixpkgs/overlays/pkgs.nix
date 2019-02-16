self: super:

{
  dotfiles-sh = super.callPackage ../pkgs/dotfiles-sh.nix {};
  androidsdk = super.callPackage ../pkgs/androidsdk {};
  nmcli-rofi = super.callPackage ../pkgs/nmcli-rofi.nix {};
  scripts = super.callPackage ../pkgs/scripts.nix {};
}
