set -x RUBY_CONFIGURE_OPTS --with-openssl-dir=(brew --prefix openssl@1.1)
set -x GOPATH $HOME/go

status --is-interactive; and source (rbenv init -|psub)

fish_add_path -g $HOME/.cargo/bin $GOPATH/bin $HOME/.local/bin

abbr -a lg lazygit
