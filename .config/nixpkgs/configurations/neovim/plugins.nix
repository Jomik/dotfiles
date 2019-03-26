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
    version = "0.0.62";

    src = fetchFromGitHub {
      owner = "neoclide";
      repo = pname;
      rev = "v${version}";
      sha256 = "1x0iivjyijrp69bl6j2ni74whnm2m30pcml0dv1b3311gdp4cy9r";
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
  defx-nvim = buildVimPluginFrom2Nix {
    pname = "defx-nvim";
    version = "2019-03-02";
    src = fetchFromGitHub {
      owner = "shougo";
      repo = "defx.nvim";
      rev = "5e13e29cd69f67a3f4474822b890ef9c479119f8";
      sha256 = "17gfj5kagr24kr85mna37pir69wd4542935l872581xhy3kiga1w";
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
}
