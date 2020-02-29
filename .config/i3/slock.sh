#!/usr/bin/env bash

screen=/run/user/$UID/lock.png

insidecolor=00000000
ringcolor=ffffffff
keyhlcolor=d23c3dff
bshlcolor=d23c3dff
separatorcolor=00000000
insidevercolor=00000000
insidewrongcolor=d23c3dff
ringvercolor=ffffffff
ringwrongcolor=ffffffff
verifcolor=ffffffff
timecolor=ffffffff
datecolor=ffffffff
loginbox=00000066
font="sans-serif"
locktext='Type password to unlock...'

# $1: number of pixels to convert
# $2: 1 for width. 2 for height
logical_px() {
	# get dpi value from xrdb
	local DPI
	DPI=""$(xdpyinfo | sed -En "s/\s*resolution:\s*([0-9]*)x([0-9]*)\s.*/\\$2/p" | head -n1)

	# return the default value if no DPI is set
	if [ -z "$DPI" ]; then
		echo "$1"
	else
		local SCALE
		SCALE=$(echo "scale=2; $DPI / 96.0" | bc)

		# check if scaling the value is worthy
		if [ "$(echo "$SCALE > 1.25" | bc -l)" -eq 0 ]; then
			echo "$1"
		else
			echo "$SCALE * $1 / 1" | bc
		fi
	fi
}

rectangles=" "
SR=$(xrandr --query | grep ' connected' | grep -o '[0-9][0-9]*x[0-9][0-9]*[^ ]*')
for RES in $SR; do
  SRA=(${RES//[x+]/ })
  CX=$((SRA[2] + $(logical_px 25 1)))
  CY=$((SRA[1] - $(logical_px 30 2)))
  rectangles+="rectangle $CX,$CY $((CX+$(logical_px 300 1))),$((CY-$(logical_px 80 2))) "
done

maim "$screen"
convert "$screen" -scale 5% -sample 2000% -quality 30 -draw "fill #$loginbox $rectangles" "$screen"

i3lock \
  -t -i "$screen" \
  --timepos='x+110:h-70' \
  --datepos='x+43:h-45' \
  --clock --date-align 1 --datestr "$locktext" \
  --insidecolor="$insidecolor" --ringcolor="$ringcolor" --line-uses-inside \
  --keyhlcolor="$keyhlcolor" --bshlcolor="$bshlcolor" --separatorcolor="$separatorcolor" \
  --insidevercolor="$insidevercolor" --insidewrongcolor="$insidewrongcolor" \
  --ringvercolor="$ringvercolor" --ringwrongcolor="$ringwrongcolor" --indpos='x+280:h-70' \
  --radius=20 --ring-width=4 --veriftext='' --wrongtext='' \
  --verifcolor="$verifcolor" --timecolor="$timecolor" --datecolor="$datecolor" \
  --time-font="$font" --date-font="$font" --layout-font="$font" --verif-font="$font" --wrong-font="$font" \
  --noinputtext='' --force-clock "$lockargs"

rm "$screen"
