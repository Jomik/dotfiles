set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
set -x JAVA_HOME /usr/lib/jvm/default
set -x ANDROID_HOME /opt/android-sdk
set -x VISUAL /usr/bin/nvim
set -x EDITOR /usr/bin/nvim
set -x XDG_CONFIG_HOME $HOME/.config

set -x PATH $ANDROID_HOME/emulator $ANDROID_HOME/tools $ANDROID_HOME/tools/bin $ANDROID_HOME/platform-tools $XDG_CONFIG_HOME/git/scripts $PATH

abbr -a ls exa
abbr -a ll exa -lha
abbr -a lt exa --tree
abbr -a psg 'ps aux | rg -v rg | rg -i -e VSZ -e'
abbr -a grep rg
abbr -a cat bat

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Start X at login
if status is-login
    if test -z "$DISPLAY" -a $XDG_VTNR = 1
        exec startx -- -keeptty
    end
end

