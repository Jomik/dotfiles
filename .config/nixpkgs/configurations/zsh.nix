{ pkgs, ... }:

{
  programs.zsh = {
    enableAutosuggestions = true;
    shellAliases = {
      ls = "exa";
      ll = "exa -lha";
      psg = "ps aux | rg -v rg | rg -i -e VSZ -e";
      e = "emacsclient -nc";
      E = "sudoedit";
      mkdir = "mkdir -pv";
      ports = "ss -tulanp";
    };
    plugins = [
      {
        name = "spaceship-prompt";
        src = pkgs.fetchFromGitHub {
          owner = "denysdovhan";
          repo = "spaceship-prompt";
          rev = "v3.10.0";
          sha256 = "03rjc3y24sz97x1fi6g66ky0pgw2q6z5r33vaprvnd2axay8pbdz";
        };
        file = "spaceship.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "2f3b98ff6f94ed1b205e8c47d4dc54e6097eacf4";
          sha256 = "1lyas0ql3v5yx6lmy8qz13zks6787imdffqnrgrpfx8h69ylkv71";
        };
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-history-substring-search";
          rev = "v1.0.1";
          sha256 = "0lgmq1xcccnz5cf7vl0r0qj351hwclx9p80cl0qczxry4r2g5qaz";
        };
      }
    ];
  };
}
