{ pkgs, stdenv, vimUtils, fetchurl, fetchFromGitHub }:


with vimUtils;

let
  yarn2nix = pkgs.callPackage (pkgs.fetchFromGitHub {
    owner = "moretea";
    repo = "yarn2nix";
    rev = "780e33a07fd821e09ab5b05223ddb4ca15ac663f";
    sha256 = "1f83cr9qgk95g3571ps644rvgfzv2i4i7532q8pg405s4q5ada3h";
  }) {};
in {
  coc-nvim = let
    pname = "coc.nvim";
    version = "0.0.64";

    src = fetchFromGitHub {
      owner = "neoclide";
      repo = pname;
      rev = "v${version}";
      sha256 = "03y8xq3g3psra9f2804czgvzyb4kslajbqdlm718r728z6iis66c";
    };

    deps = yarn2nix.mkYarnModules rec {
      inherit version pname;
      name = "${pname}-modules-${version}";
      packageJSON = src + "/package.json";
      yarnLock = src + "/yarn.lock";
    };
  in buildVimPluginFrom2Nix {
    inherit version pname src;

    configurePhase = ''
      mkdir -p node_modules
      ln -s ${deps}/node_modules/* node_modules/
      ln -s ${deps}/node_modules/.bin node_modules/
    '';

    buildPhase = ''
      ${pkgs.yarn}/bin/yarn build
    '';

    postFixup = ''
      substituteInPlace $target/autoload/coc/util.vim \
        --replace "'yarnpkg'" "'${pkgs.yarn}/bin/yarnpkg'"
      substituteInPlace $target/autoload/health/coc.vim \
        --replace "'yarnpkg'" "'${pkgs.yarn}/bin/yarnpkg'"
    '';
  };

  ale = buildVimPluginFrom2Nix {
    pname = "ale";
    version = "2.3.1";

    src = fetchFromGitHub {
      owner = "w0rp";
      repo = "ale";
      rev = "v2.3.1";
      sha256 = "1qrm2iv2jkx4i9ki9yrkki1rfsq5khbimz3pl8gfq9mxig6m4p3d";
    };
  };

  comfortable-motion = buildVimPluginFrom2Nix {
    pname = "comfortable-motion";
    version = "2018-02-22";

    src = fetchFromGitHub {
      owner = "yuttie";
      repo = "comfortable-motion.vim";
      rev = "e20aeafb07c6184727b29f7674530150f7ab2036";
      sha256 = "13chwy7laxh30464xmdzjhzfcmlcfzy11i8g4a4r11m1cigcjljb";
    };
  };

  vim-numbertoggle = buildVimPluginFrom2Nix {
    pname = "vim-numbertoggle";
    version = "2017-10-26";
    src = fetchFromGitHub {
      owner = "jeffkreeftmeijer";
      repo = "vim-numbertoggle";
      rev = "cfaecb9e22b45373bb4940010ce63a89073f6d8b";
      sha256 = "1rrmvv7ali50rpbih1s0fj00a3hjspwinx2y6nhwac7bjsnqqdwi";
    };
  };

  which-key = buildVimPluginFrom2Nix {
    pname = "vim-which-key";
    version = "2019-02-28";
    src = fetchFromGitHub {
      owner = "liuchengxu";
      repo = "vim-which-key";
      rev = "3df05b678736e7c3f744a02f0fd2958aa8121697";
      sha256 = "1jpkgq2plwnyiv6bqhly3v36sk3k8bn575q5gj2jdvd7fkk7v9pw";
    };
  };

  vim-sandwich = buildVimPluginFrom2Nix {
    pname = "vim-sandwich";
    version = "2019-02-28";
    src = fetchFromGitHub {
      owner = "machakann";
      repo = "vim-sandwich";
      rev = "d441cf5a450f65dbf95eca3fa1138806884a7d58";
      sha256 = "1qkadkisfw21834848rphliry5h6h9mj010n2p3y27wp6xkq9phj";
    };
  };

  vim-startify = buildVimPluginFrom2Nix {
    pname = "vim-startify";
    version = "2019-04-6";
    src = fetchFromGitHub {
      owner = "mhinz";
      repo = "vim-startify";
      rev = "c758d2a79ae0e4b8602e09834800ed0b3d71d0fe";
      sha256 = "0h43lwni05b80kwhfpwlvs3pakqw4csk6k5w638c2xrjxqr7jjfh";
    };
  };

  tla = buildVimPluginFrom2Nix {
    pname = "tla-vim";
    version = "2018-01-31";

    src = fetchFromGitHub {
      owner = "florentc";
      repo = "vim-tla";
      rev = "a76fbdd8bd7254dd24d610aba5a824f4fac3ad56";
      sha256 = "1n2yi466dw1s9dpa7ry7p9xr2pb3rkgppkvnqj1hfl9cqv7fg416";
    };
  };

  defx-nvim = buildVimPluginFrom2Nix {
    pname = "defx-nvim";
    version = "2019-04-04";
    src = fetchFromGitHub {
      owner = "shougo";
      repo = "defx.nvim";
      rev = "78cba6f1386d194d012bbd406961650c59d224d8";
      sha256 = "0qa0n07w2gmhbp4k898vqy89rsbfzwppng616g6dwx6g723f2m3z";
    };
  };

  defx-git = buildVimPluginFrom2Nix {
    pname = "defx-git";
    version = "2019-03-02";
    src = fetchFromGitHub {
      owner = "kristijanhusak";
      repo = "defx-git";
      rev = "bb1ec337838870b1b966826ad24c109073d2a9ac";
      sha256 = "1xg17bvqqad1723ps6h4pwfnkxffkk3y6nz0qx9d00ryxcc312x1";
    };
  };

  vim-matchup = buildVimPluginFrom2Nix {
    pname = "vim-matchup";
    version = "2019-03-13";
    src = fetchFromGitHub {
      owner = "andymass";
      repo = "vim-matchup";
      rev = "afbf309610953a2ff6144ef9746b9e8b34b61dba";
      sha256 = "1qvw2wzjz6zqsz526lx8hmd9lh61b55j8d321sf8dr6f2670s1lj";
    };
  };
}
