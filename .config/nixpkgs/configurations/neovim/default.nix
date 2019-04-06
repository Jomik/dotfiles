{ pkgs, ... }:

let
  vimPlugins = pkgs.vimPlugins // pkgs.callPackage ./plugins.nix {};

  fzf = vimPlugins.fzfWrapper.overrideAttrs (old: {
    postFixup = ''
      substituteInPlace $out/share/vim-plugins/fzf/plugin/fzf.vim \
        --replace "s:base_dir.'/bin/fzf'" "'${pkgs.fzf}/bin/fzf'"
    '';
  });
in
{
  nixpkgs.overlays = [
    (self: super: {
      neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldattrs: {
        version = "0.4.0";
       src = pkgs.fetchFromGitHub {
          owner = "neovim";
          repo = "neovim";
          rev = "36762a00a8010c5e14ad4347ab8287d1e8e7e064";
          sha256 = "0n7i3mp3wpl8jkm5z0ifhaha6ljsskd32vcr2wksjznsmfgvm6p4";
        };
      });
    })
  ];

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
          ale
          coc-nvim
          comfortable-motion
          defx-git
          defx-nvim
          direnv-vim
          echodoc
          fzf
          fzf-vim
          gitgutter
          gruvbox
          idris-vim
          sensible
          tla
          typescript-vim
          vim-commentary
          vim-highlightedyank
          vim-matchup
          vim-nix
          vim-numbertoggle
          vim-peekaboo
          vim-sandwich
          vim-startify
        ];
      };
    };
  };
}
