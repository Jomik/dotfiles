#!/bin/bash

confirm() {
    echo -e "Yes\nNo" | rofi -dmenu -i -format d -selected-row 1 -p "${1:-Confirm: }"
}

lock="Lock"
suspend="Suspend"
reboot="Reboot"
shutdown="Shutdown"
reload="Reload i3 configuration"

content="$lock\n$suspend\n$reboot\n$shutdown\n$reload"

selection=$(echo -e $content | rofi -dmenu -i -markup-rows -p "Action: ")
case $selection in
    $lock)
        loginctl lock-session $XDG_SESSION_ID ;;
    $suspend)
        [[ $(confirm) = 1 ]] && (systemctl suspend -i) ;;
    $reboot)
        [[ $(confirm) = 1 ]] && (systemctl reboot -i) ;;
    $shutdown)
        [[ $(confirm) = 1 ]] && (systemctl poweroff -i) ;;
    $reload)
        i3-msg reload
        i3-msg restart ;;
esac
