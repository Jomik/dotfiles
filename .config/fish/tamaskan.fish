set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
set -x JAVA_HOME /usr/lib/jvm/default
set -x ANDROID_HOME /opt/android-sdk
set -x VISUAL /usr/bin/nvim
set -x XDG_CONFIG_HOME $HOME/.config

set -x PATH $ANDROID_HOME/emulator $ANDROID_HOME/tools $ANDROID_HOME/tools/bin $ANDROID_HOME/platform-tools $XDG_CONFIG_HOME/git/scripts $PATH
