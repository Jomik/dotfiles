{ pkgs, config, lib, ... }:

{
  home.file.".bashrc" = lib.mkIf config.programs.fish.enable {
    text = ''
        exec ${config.programs.fish.package}/bin/fish
    '';
  };

  programs.fish = {
    shellAbbrs = {
      ls = "exa";
      ll = "exa -lha";
      lt = "exa --tree";
      psg = "ps aux | rg -v rg | rg -i -e VSZ -e";
      e = "emacsclient -nc";
      E = "sudoedit";
      grep = "rg";
      cat = "bat";
    };
    functions = {
      # Workaround for bash in nix-shell. Needed when .bashrc contains exec fish
      nix-shell.body = "command nix-shell --run 'bash --norc' $argv";
      bash.body = "command bash --norc";
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
      z.body = ''
          fasd_cd -d $argv
      '';
    };
    completions = {
      z.body = ''complete -c z -a "(__fasd_print_completion -d)" -f'';
    };
    plugins = with pkgs.nur.repos.jomik.fishPlugins; [
      fasd
      spacefish
      thefuck
    ];
  };
}
