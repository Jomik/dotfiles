#!/run/current-system/sw/bin/fish

set dotfiles ~/.dotfiles

# message $msg $color
function message
    set -l msg $argv[1]
    set -l color $argv[2]
    set_color $color
    echo -e $msg
    set_color normal
end

# linkFiles $src $dist $depth $filter $prefix
# $src Decides the relative source to $dotfiles.
# $dist is the root folder to create links to.
# $depth is the depth to use with find, 1 is only the $src folder.
# $filter is the filter to use when selecting files to source. Useful if some
# files should be ignored.
# $prefix is the prefix to prepend on every symlinked file. Let's us keep repo
# files without the dot.
# $strip is used to strip a suffix from a file, useful together with filter.
#
# Example:
# linkFiles $dotfiles/home ~ 1 "*.symlink" "." ".symlink"
# Only select files in home that is appended with symlink, then strip it from
# them and prepend a dot when linking.
function linkFiles
    set -l src $argv[1]
    set -l dist $argv[2]/
    set -l depth $argv[3]
    set -l filter $argv[4]
    set -l prefix $argv[5]
    set -l strip $argv[6]

    message "\nCreating symlinks for $dist" blue
    message "==================================================" blue

    for file in (find -H $src -maxdepth $depth -name $filter)
        # Test if it is a file.
        if test -f $file
            # Strip the path and prepend our prefix.
            set -l targetFile {$prefix}(basename $file $strip)
            # Strip off the source path so we can prepend distination path.
            set -l targetDir {$dist}(echo $file | sed 's|^'$src'/||')
            # Strip off the file part so we can append targetFile
            set -l targetDir (echo $targetDir | sed 's|'(basename $targetDir)'$||')
            # Create our target file.
            set -l target {$targetDir}{$targetFile}
            #echo "File: "{$file}
            #echo "Target: "{$target}

            # Check if target exists.
            if test -e $target
                # Target is a link
                if test -L $target
                    # Check if the link points to our target
                    if test (readlink $target) != $file
                        # Link exists but it doesn't point to our source file.
                        message "Please delete invalid link; $target" red
                    else
                        # It's the right link!
                        message "Already linked; $target" green
                    end
                else
                    message "Please delete existing file/folder; $target" red
                end
            else # Link doesn't exist
                if test -L $target
                    # Dead link, we can delete it.
                    message "Deleted dead link; $target" yellow
                    rm $target
                end
                # Ensure that the directory exists
                if not test -d (dirname $target)
                    message "Created; "(dirname $target) yellow
                    mkdir -p (dirname $target)
                end
                # Attempt to create link
                if ln -s $file $target
                    # Success
                    message "Linked; $target" green
                else
                    # Failure
                    message "Failed; $target" red
                end
            end
        end
    end
end

linkFiles $dotfiles/home ~ 1 "*" "." ""
linkFiles $dotfiles/config ~/.config 2 "*" "" ""
linkFiles $dotfiles/vim ~/.vim 2 "*" "" ""
linkFiles $dotfiles/xmonad ~/.xmonad 1 "*" "" ""
linkFiles $dotfiles/weechat ~/.weechat 3 "*" "" ""
