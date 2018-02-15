set -x EDITOR vi
set -x NPM_PACKAGES $HOME/.npm-packages
set PATH $NPM_PACKAGES/bin $PATH

set -x ANDROID_HOME $HOME/android-sdk
set -x PATH $ANDROID_HOME/tools $PATH
set -x PATH $ANDROID_HOME/platform-tools $PATH
set -x PATH $HOME/.gem/ruby/2.5.0/bin $PATH
set -x CHROME_BIN chromium

set -x Q_INSPECT_NOTIFY_EMAIL jonasdamtoft@hotmail.com
