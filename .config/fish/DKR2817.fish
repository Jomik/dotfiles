set -x RUBY_CONFIGURE_OPTS --with-openssl-dir=(brew --prefix openssl@1.1)
set -x GOPATH $HOME/go

status --is-interactive; and source (rbenv init -|psub)

fish_add_path $HOME/.cargo/bin
fish_add_path $GOPATH/bin
fish_add_path $HOME/.local/bin

abbr -a lg lazygit
