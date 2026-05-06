function pis --description "Run pi in a Docker sandbox"
    set -l kit ~/.pi/pi-kit
    set -l mixins tools kitty-clipboard obsidian

    # Derive sandbox name from a path
    function __pis_sandbox_name
        set -l target (test -n "$argv[1]"; and echo $argv[1]; or echo .)
        set -l resolved (realpath $target 2>/dev/null; or echo $target)
        echo "pi-"(basename $resolved)
    end

    # Ensure obsidian CLI bridge is running
    if not lsof -i :57843 >/dev/null 2>&1
        node $kit/mixins/obsidian/bridge.js &
        disown
    end

    function __pis_run
        set -l kit $argv[1]
        set -l mixins (string split , $argv[2])
        set -l path $argv[3]
        set -l extra $argv[4..]
        set -l name (__pis_sandbox_name $path)

        if sbx ls --quiet 2>/dev/null | grep -qx $name
            sbx run --kit $kit $name
        else
            set -l kit_flags --kit $kit
            for m in $mixins
                set -a kit_flags --kit $kit/mixins/$m
            end
            sbx run $kit_flags pi $path $extra
        end
    end

    switch "$argv[1]"
        case sync
            set -l name (__pis_sandbox_name $argv[2])
            $kit/sync.sh
            sbx kit add $name $kit
            for m in $mixins
                sbx kit add $name $kit/mixins/$m
            end
        case rm
            set -l name (__pis_sandbox_name $argv[2])
            sbx rm $name
        case ''
            __pis_run $kit (string join , $mixins) .
        case '*'
            __pis_run $kit (string join , $mixins) $argv
    end

    functions -e __pis_sandbox_name __pis_run
end
