set -q XDG_CONFIG_HOME; or set -x XDG_CONFIG_HOME ~/.config
source $XDG_CONFIG_HOME/fish/(hostname).fish

# Workaround for regression: https://github.com/nvbn/thefuck/issues/1219
set -x THEFUCK_PRIORITY "git_hook_bypass=1100"

set -x EDITOR /usr/local/bin/nvim

fish_add_path $XDG_CONFIG_HOME/git/scripts $PATH

if ! status is-interactive
  exit
end

if ! functions --query fisher
    curl --silent --location https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

thefuck --alias | source

builtin source $XDG_CONFIG_HOME/fish/abbreviations.fish
