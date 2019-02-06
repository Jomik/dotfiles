{ pkgs, ... }:

{
  programs.emacs.overrides = self: super: {
    tla-mode = self.melpaBuild {
      pname = "tla-mode";
      version = "1.0.0";
      src = pkgs.fetchFromGitHub {
        owner = "ratish-punnoose";
        repo = "tla-mode";
        rev = "ab604ba3739ad613599ccee7bc7cb4c9a7b84f5c";
        sha256 = "1q9pnf4hdan7y4gyxssgdarprdf3wjv5gflnirbpfqq7fyfihwxw";
      };
      recipe = pkgs.writeText "recipe" ''
        (tla-mode
        :repo "ratish-punnoose/tla-mode"
        :fetcher github)
      '';
    };
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
    use-package = self.melpaBuild {
      pname = "use-package";
      version = "20181119.2350";
      src = pkgs.fetchFromGitHub {
        owner = "jwiegley";
        repo = "use-package";
        rev = "39a8b8812c2c9f6f0b299e6a04e504ef393694ce";
        sha256 = "1b7mjjh0d6fmkkd9vyj64vca27xqhga0nvyrrcqxpqjn62zq046y";
      };
      recipe = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/melpa/melpa/51a19a251c879a566d4ae451d94fcb35e38a478b/recipes/use-package";
        sha256 = "0d0zpgxhj6crsdi9sfy30fn3is036apm1kz8fhjg1yzdapf1jdyp";
        name = "use-package";
      };
    };
  };
}
