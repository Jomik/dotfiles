set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
source $XDG_CONFIG_HOME/fish/(hostname).fish

set -x PATH $XDG_CONFIG_HOME/git/scripts $PATH

abbr -a ls exa
abbr -a ll exa -lha
abbr -a lt exa --tree
abbr -a psg 'ps aux | rg -v rg | rg -i -e VSZ -e'
abbr -a grep rg
abbr -a cat bat

if status is-interactive && ! functions --query fisher
    curl --silent --location https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

