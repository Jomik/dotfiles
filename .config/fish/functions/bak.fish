# Defined in /tmp/fish.pHKTVQ/bak.fish @ line 1
function bak
	for file in $argv
    cp $file $file.bak
  end
end
