set -q XDG_CACHE_HOME; or set -x XDG_CACHE_HOME ~/.cache
set -q XDG_CONFIG_HOME; or set -x XDG_CONFIG_HOME ~/.config
source $XDG_CONFIG_HOME/fish/(hostname).fish

if type -q nvim
    set -x EDITOR (which nvim)
end

fish_add_path $XDG_CONFIG_HOME/git/scripts $PATH

if ! status is-interactive
    exit
end

if ! functions --query fisher
    curl --silent --location https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

if type -q thefuck
    thefuck --alias | source
end

if type -q rtx
    rtx activate fish | source
end

builtin source $XDG_CONFIG_HOME/fish/abbreviations.fish
