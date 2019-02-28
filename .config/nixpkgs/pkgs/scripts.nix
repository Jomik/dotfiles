{ pkgs, lib, ... }:

with lib;
{
  slock = let
    path = makeBinPath (with pkgs; [
      coreutils
      i3lock-color
      scrot
      imagemagick
    ]);
  in pkgs.writeShellScriptBin "slock" ''
    export PATH=${path}
    screen=/run/user/$UID/screen.png

    convert x:root -scale 5% -sample 2000% -quality 30 $screen
    i3lock-color -n -i $screen \
        --insidecolor=373445ff --ringcolor=ffffffff --line-uses-inside \
        --keyhlcolor=d23c3dff --bshlcolor=d23c3dff --separatorcolor=00000000 \
        --insidevercolor=fecf4dff --insidewrongcolor=d23c3dff \
        --ringvercolor=ffffffff --ringwrongcolor=ffffffff --indpos="x+86:y+1003" \
        --radius=15 --veriftext="" --wrongtext=""

    pid=$!
    wait $pid
    [ -f "$screen" ] && rm $screen
  '';
  rofi-menu = name: menu: pkgs.writeShellScriptBin name ''
    launcher="${pkgs.rofi}/bin/rofi -dmenu -i -hide-scrollbar"
    options="${concatMapStringsSep "\\n" head menu}"

    if [[ $? -ne 0 ]]; then
    exit 0
    fi

    choice=$(echo -e $options | $launcher -p ${name} -lines ${toString (length menu)})
    case $choice in
    ${concatMapStringsSep "\n"
      (e: ''${head e})
      ${optionalString (last e) ''
            confirmed=$(echo -e "Yes\nNo" | $launcher -lines 2 -p "''${choice}?" -selected-row 1)
            if [[ $? -ne 0 || "''${confirmed}" == "No" ]]; then
              exit 0
            fi
''}
            ${elemAt e 1}
            ;;'')
    menu}
    esac
  '';
}
