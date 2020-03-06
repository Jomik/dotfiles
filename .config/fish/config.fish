set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config

source $XDG_CONFIG_HOME/fish/(hostname).fish

abbr -a ls exa
abbr -a ll exa -lha
abbr -a lt exa --tree
abbr -a psg 'ps aux | rg -v rg | rg -i -e VSZ -e'
abbr -a grep rg
abbr -a cat bat

if not functions -q fisher
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

