abbr -a ls exa
abbr -a ll exa -lha
abbr -a lt exa --tree
abbr -a psg 'ps aux | rg -v rg | rg -i -e VSZ -e'
abbr -a grep rg
abbr -a cat bat

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end

abbr -a dotdot --regex '^\.\.+$' --function multicd

