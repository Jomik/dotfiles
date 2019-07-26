{ lib, pkgs, ... }:

with lib;
let
  vimPlugins = pkgs.vimPlugins // pkgs.nur.repos.jomik.vimPlugins;

  fzf = vimPlugins.fzfWrapper.overrideAttrs (old: {
    postFixup = ''
      substituteInPlace $out/share/vim-plugins/fzf/plugin/fzf.vim \
        --replace "s:base_dir.'/bin/fzf'" "'${pkgs.fzf}/bin/fzf'"
    '';
  });

  cocSettings = {
    "coc.preferences.formatOnSaveFiletypes" = ["tsx" "typescript"];
    "codeLens.enable" = true;
    "prettier.requireConfig" = true;
    languageserver = {
      rls = {
        command = "${pkgs.rls}/bin/rls";
        filetypes = ["rust"];
      };
      dls = {
        command = "${pkgs.nur.repos.jomik.diagnostic-languageserver}/bin/diagnostic-languageserver";
        args = ["--stdio"];
        filetypes = ["lsl"];
        initializationOptions = {
          linters = {
            lslint = {
              command = "${pkgs.nur.repos.jomik.lslint}/bin/lslint-wrapped";
              sourceName = "lslint";
              isStdout = true;
              isStderr = true;
              formatPattern = [
                "^\\s*(.+):: \\(\\s*(\\d+),\\s*(\\d+)\\): (.+)$"
                { 
                  line = 2;
                  column = 3;
                  message = [4];
                  security = 1;
                }
              ];
              securities = {
                "ERROR" = "error";
                "WARN" = "warning";
              };
            };
          };
          filetypes = {
            lsl = "lslint";
          };
        };
      };
    };
  };
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

  xdg.configFile = {
    "nvim/coc-settings.json".text = builtins.toJSON cocSettings;
  };

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;

    package = pkgs.neovim-unwrapped.overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs ++ (with pkgs; [ makeWrapper ]);
      postFixup = ''
        wrapProgram $out/bin/nvim \
          --prefix PATH : ${makeBinPath (with pkgs; [ yarn ])}
      '';
    });

    configure= {
      customRC = ''
        let $RUST_SRC_PATH = '${pkgs.rustPlatform.rustcSrc}'
        source ~/.config/nvim/init.vim
      '';

      packages.myVimPackage = with vimPlugins; {
        start = [
          ale
          clever-f
          coc-nvim
          comfortable-motion
          defx-git
          defx-nvim
          direnv-vim
          echodoc
          fzf
          fzf-vim
          git-messenger
          gitgutter
          gruvbox
          idris-vim
          lightline
          lslvimazing
          markdown
          markdown-preview
          quick-scope
          rust-vim
          search-pulse
          sensible
          tcomment
          tla
          typescript-vim
          vim-highlightedyank
          vim-matchup
          vim-nix
          vim-numbertoggle
          vim-peekaboo
          vim-sandwich
          vim-startify
          vim-tsx
        ];
      };
    };
  };
}
