export RUBY_CONFIGURE_OPTS="--with-openssl-dir=(brew --prefix openssl@1.1)"
status --is-interactive; and source (rbenv init -|psub)
