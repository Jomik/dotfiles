{ vimUtils, fetchFromGitHub }:

with vimUtils;
{
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
  vim-closer = buildVimPluginFrom2Nix {
    pname = "vim-closer";
    version = "2019-02-28";
    src = fetchFromGitHub {
      owner = "ozelentok";
      repo = "vim-closer";
      rev = "f2c46c3739ed045d126858b2cfc4b8e25a386e44";
      sha256 = "02x32qak9cp9v5vv0rc25hiajj20pq1fi2s9kljskcqap3bi8cac";
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
