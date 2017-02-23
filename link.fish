#!/run/current-system/sw/bin/fish
# The above is for NixOS.
# Use '#!/bin/fish' on "normal" distros.

set dotfiles ~/.dotfiles

# message $msg $color
function message
    set -l msg $argv[1]
    set -l color $argv[2]
    set_color $color
    echo -e $msg
    set_color normal
end

# linkFiles $src $dist $prefix $strip $depth [$filter]
# $src Decides the relative source to $dotfiles.
# $dist is the root folder to create links to.
# $prefix is the prefix to prepend on every symlinked file. Let's us keep repo
# files without the dot.
# $strip is used to strip a suffix from a file, useful together with filter.
# $depth is the depth to use with find, 1 is only the $src folder.
# $filter is the filter to use when selecting files to source. Useful if some
# files should be ignored. Ex. -name "*.symlink"
#
# Examples:
#linkFiles $dotfiles/home ~ "." "*.symlink" 1 -name "*.symlink"
#linkFiles $dotfiles/Xresources ~ "." "" 1 -name "Xresources"
#linkFiles $dotfiles/Xresources ~/.Xresources.d "" "" 1 ! -name "Xresources"
function linkFiles
    set -l src $argv[1]
    set -l dist $argv[2]/
    set -l prefix $argv[3]
    set -l strip $argv[4]

    message "\nCreating symlinks for $dist" blue
    message "==================================================" blue

    for file in (find -H $src -maxdepth $argv[5..-1])
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

linkFiles $dotfiles/home ~ "." "" 1
linkFiles $dotfiles/zsh ~/.zsh "" "" 1
linkFiles $dotfiles/emacs ~/.emacs.d "" "" 1
linkFiles $dotfiles/i3 ~/.config/i3 "" "" 1
linkFiles $dotfiles/fish ~/.config/fish "" "" 1
linkFiles $dotfiles/vim ~/.vim "" "" 2
linkFiles $dotfiles/nvim ~/.config/nvim "" "" 2
linkFiles $dotfiles/weechat ~/.weechat "" "" 3
