{ pkgs, config, lib, ... }:

{
  imports = [ ../modules/programs/fish ];

  home.file.".bashrc" = lib.mkIf config.programs.fish.enable {
    text = ''
        exec ${config.programs.fish.package}/bin/fish
    '';
  };

  programs.fish = {
    shellAbbrs = {
      ls = "exa";
      ll = "exa -lha";
      psg = "ps aux | rg -v rg | rg -i -e VSZ -e";
      e = "emacsclient -nc";
      E = "sudoedit";
      grep = "rg";
      cat = "bat";
    };
    functions = {
      mkdir.body = "command mkdir -pv $argv";
      ports.body = "command ss -tulanp";
      init-envrc.body = ''
        if test -f shell.nix; or test -f .envrc
          echo shell.nix or .envrc already exists
          return 1
        else
          echo "with import <nixpkgs> {};" > shell.nix
          echo "" >> shell.nix
          echo "let" >> shell.nix
          echo "  inherit (pkgs) mkShell;" >> shell.nix
          echo "in mkShell {" >> shell.nix
          echo "  buildInputs = with pkgs; [" >> shell.nix
          echo -e "   " (string join "\n    " $argv) >> shell.nix
          echo "  ];" >> shell.nix
          echo "}" >> shell.nix
          echo "use nix" > .envrc
          command direnv allow .
          return 0
        end
      '';
    };
    plugins = plugins: with plugins; [
      prompt.spacefish
      thefuck
    ];
  };
}
