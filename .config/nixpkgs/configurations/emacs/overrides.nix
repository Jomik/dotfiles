{ pkgs, ... }:

{
  programs.emacs.overrides = self: super: {
    general = self.melpaBuild {
      pname = "general";
      version = "20181229.1542";
      src = pkgs.fetchFromGitHub {
        owner = "noctuid";
        repo = "general.el";
        rev = "675050199b5a30d54a24b58a367db32c0bdc47f5";
        sha256 = "175yyhzk57yk1sskxh3d2jzhrh2waiibbcfsll167qxr117yji5h";
      };
      recipe = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/melpa/melpa/c28877ac5497f4764a9d3208bd87f81dbab46fe3/recipes/general";
        sha256 = "104ywsfylfymly64p1i3hsy9pnpz3dkpmcq1ygafnld8zjd08gpc";
        name = "general";
      };
    };
    evil-collection = self.melpaBuild {
      pname = "evil-collection";
      version = "20181224.2351";
      src = pkgs.fetchFromGitHub {
        owner = "emacs-evil";
        repo = "evil-collection";
        rev = "4737aa47438a565119652212c16dade59f23b785";
        sha256 = "0lzwcmsm0igvh1jhjq2a8ipa2pf4lw7lm04xfxf7xj1ai30l7i40";
      };
      recipe = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/melpa/melpa/fbc35279115f6fdf1ce7d1ecef3b413c7ca9c4f1/recipes/evil-collection";
        sha256 = "1l6x782ix873n90k9g00i9065h31dnhv07bgzrp28l7y7bivqwl7";
        name = "evil-collection";
      };
    };
  };
}