set -q XDG_CACHE_HOME; or set -x XDG_CACHE_HOME $HOME/.cache
set -q XDG_CONFIG_HOME; or set -x XDG_CONFIG_HOME $HOME/.config
set -q XDG_STATE_HOME; or set -x XDG_STATE_HOME $HOME/.local/state
set -q XDG_DATA_HOME; or set -x XDG_DATA_HOME $HOME/.local/share

set --local local_conf $XDG_CONFIG_HOME/fish/(hostname).fish
if test -e $local_conf
    builtin source $local_conf
end

fish_add_path -g $XDG_CONFIG_HOME/git/scripts

if type -q nvim
    set -x EDITOR (which nvim)
end

if ! status is-interactive
    exit
end

if ! functions --query fisher
    curl --silent --location https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

if type -q thefuck
    thefuck --alias | source
end

builtin source $XDG_CONFIG_HOME/fish/abbreviations.fish
