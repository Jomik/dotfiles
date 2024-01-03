fish_add_path -g /opt/homebrew/bin $HOME/.cargo/bin $HOME/.local/bin

set -x RUBY_CONFIGURE_OPTS --with-openssl-dir=(brew --prefix openssl@1.1)

if status --is-interactive; and type -q rbenv
    source (rbenv init -|psub)
end

abbr -a lg lazygit
