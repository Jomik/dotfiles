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
    rofi=${pkgs.rofi}/bin/rofi
    # menu defined as an associative array
    declare -A menu
    declare -a order=()

    # Menu with keys/commands
    ${concatMapStringsSep "\n"
      (e: ''menu[${elemAt e 0}]="${elemAt e 1}"; order+=("${elemAt e 0}")'')
      menu}
    menu_nrows=''${#menu[@]}

    confirm="${concatMapStringsSep " " head (filter last menu) }"

    launcher="''${rofi} -dmenu -i -lines ''${menu_nrows}"
    selection="$(printf '%s\n' "''${order[@]}" | $launcher)"
    if [[ $? -eq 0 && ! -z ''${selection} ]]; then
      if [[ ''${confirm} =~ (^|[[:space:]])"''${selection}"($|[[:space:]]) ]]; then
        confirmed=$(echo -e "No\nYes" | ''${rofi} -dmenu -i -lines 2 -p "''${selection}?")
        if [[ $? -ne 0 || "''${confirmed}" == "No" ]]; then
          exit 0
        fi
      fi
      ''${menu[''${selection}]}
    fi
  '';
}
