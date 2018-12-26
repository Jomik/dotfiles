pkgs:

let 
  utils = pkgs.callPackage ./../fish-utils.nix {};
in with utils; {
  prompt = {
    spacefish = pluginFromGitHub {
      owner = "matchai";
      repo = "spacefish";
      rev = "0f5a600a6c0b5861792383e69797a66923496743";
      sha256 = "07d3yhra2vfywibw218ccb423sjamqypsd2wf7gvadwizdb1l0yd";
    };
    eden = pluginFromGitHub {
      owner = "amio";
      repo = "fish-theme-eden";
      rev = "ee3291e5151d752e5c2a7fa730080dad379ad5a0";
      sha256 = "1jqmv4j2z4v40xzxfaa94vrnnl6hlnfbmv3nl0bakynrqxvrbfg9";
    };
    pure = pluginFromGitHub {
      owner = "rafaelrinaldi";
      repo = "pure";
      rev = "25b767137800b7723804576a924e44cb8c096ff4";
      sha256 = "1p9m9r6ic416p44v175wb29q3gn5jxhnjn1i9icpys7xndizxxqi";
    };
    bobthefish = pluginFromGitHub {
      owner = "oh-my-fish";
      repo = "theme-bobthefish";
      rev = "0688cd8e9801f8fba90c8f935d399a32e861f5ff";
      sha256 = "1izn34gg6gcf669dars8c25df6ws9nxcnqcfz947mrmkzg80fpzj";
    };
  };

  fasd = pluginFromGitHub {
    owner = "adityavm";
    repo = "fasd";
    rev = "a1e991b4a22a63af5f52751ef245b1b9f8a6e6d7";
    sha256 = "0a28z9davbnpwg4j9nhsbs5b7qp8wisv59xv2440yd6xzr05v59d";
    dependencies = [ pkgs.fasd ];
  };

  thefuck = pkgs.callPackage ./thefuck.nix { inherit utils; };
}
