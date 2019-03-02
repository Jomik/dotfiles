{ pkgs, ... }:

let
  vimPlugins = pkgs.vimPlugins // pkgs.callPackage ./plugins.nix {};
in
{
  programs.neovim = {
    viAlias = true;
    vimAlias = true;

    configure= {
      customRC = ''
        let mapleader=" "
        tnoremap <Esc> <C-\><C-n>
        noremap <silent> k gk
        noremap <silent> j gj
        noremap <silent> 0 g0
        noremap <silent> $ g$
        map Y y$
      '';
      packages.myVimPackage = with vimPlugins; {
        start = [
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
          vim-closer
        ];
      };
    };
  };
}
