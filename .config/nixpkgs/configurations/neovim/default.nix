{ pkgs, ... }:

let
  vimPlugins = pkgs.vimPlugins // pkgs.callPackage ./plugins.nix {};
in
{
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;

    configure= {
      customRC = ''
        source ~/.config/nvim/init.vim
      '';
      packages.myVimPackage = with vimPlugins; {
        start = [
          gruvbox
          coc-nvim
          sensible
          echodoc
          direnv-vim
          defx-nvim
          defx-git
          vim-highlightedyank
          vim-commentary
          vim-repeat
          vim-startify
          vim-sandwich
          typescript-vim
          vim-nix
        ];
      };
    };
  };
}
