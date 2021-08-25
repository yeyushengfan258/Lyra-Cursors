#!/bin/bash

function create {
	MAKEDIR="$SRC"/../build
	if [ -d $MAKEDIR ]; then
		rm -rf $MAKEDIR
	fi
	mkdir $MAKEDIR
	cd $MAKEDIR
	mkdir -p x1 x1_25 x1_5 x2
	cd "$SRC"/$1
	## This version starts up Inkscape for each file; Inkscape can 
	## take a list of files and convert them all much faster
	# find . -name "*.svg" -type f -exec sh -c 'inkscape -o "../../build/x1/${0%.svg}.png" -w 32 -h 32 $0' {} \;
	# find . -name "*.svg" -type f -exec sh -c 'inkscape -o "../../build/x1_25/${0%.svg}.png" -w 40 -w 40 $0' {} \;
	# find . -name "*.svg" -type f -exec sh -c 'inkscape -o "../../build/x1_5/${0%.svg}.png" -w 48 -w 48 $0' {} \;
	# find . -name "*.svg" -type f -exec sh -c 'inkscape -o "../../build/x2/${0%.svg}.png" -w 64 -w 64 $0' {} \;
	inkscape --export-type=png *.svg -w 32 -h 32
	mv *.png $MAKEDIR/x1
	inkscape --export-type=png *.svg -w 40 -h 40
	mv *.png $MAKEDIR/x1_25
	inkscape --export-type=png *.svg -w 48 -h 48
	mv *.png $MAKEDIR/x1_5
	inkscape --export-type=png *.svg -w 64 -h 64
	mv *.png $MAKEDIR/x2

	cd $MAKEDIR

	# generate cursors
	BUILD="$SRC"/../dist/"$THEME"-cursors
	OUTPUT="$BUILD"/cursors
	ALIASES="$SRC"/cursorList

	if [ ! -d "$BUILD" ]; then
		mkdir -p "$BUILD"
	fi
	if [ ! -d "$OUTPUT" ]; then
		mkdir "$OUTPUT"
	fi

	echo -ne "Generating cursor theme...\\r"
	for CUR in $SRC/config/*.cursor; do
		BASENAME="$CUR"
		BASENAME="${BASENAME##*/}"
		BASENAME="${BASENAME%.*}"
		
		xcursorgen "$CUR" "$OUTPUT/$BASENAME"
	done
	echo -e "Generating cursor theme... DONE"

	cd "$OUTPUT"	

	#generate aliases
	echo -ne "Generating shortcuts...\\r"
	while read ALIAS; do
		FROM="${ALIAS#* }"
		TO="${ALIAS% *}"

		if [ -e $TO ]; then
			continue
		fi
		ln -sr "$FROM" "$TO"
	done < "$ALIASES"
	echo -e "Generating shortcuts... DONE"

	cd "$PWD"

	echo -ne "Generating Theme Index...\\r"
	INDEX="$OUTPUT/../index.theme"
	if [ ! -e "$OUTPUT/../$INDEX" ]; then
		touch "$INDEX"
		echo -e "[Icon Theme]\nName=$THEME Cursors\n" > "$INDEX"
	fi
	echo -e "Generating Theme Index... DONE"
}

# ensure dependencies exist
CMDS="inkscape xcursorgen"
 
for i in $CMDS; do
  # command -v will return >0 when the $i is not found
	command -v $i >/dev/null && continue || { echo "Error: This build script requires $i to be installed."; exit 1; }
done

#select theme
THEME=$1

if [[ "$THEME" == "" ]]; then
  echo -n "Use the default theme (LyraR)? (y/n): "
  read ANSWER
  if [[ $ANSWER != "y" && $ANSWER != "yes" ]]; then
    echo -n "Please enter a theme name: "
    read NEWTHEME
    THEME=$NEWTHEME
  else
    THEME=LyraR
  fi
fi

if [ ! -d "src/$THEME-svg" ]; then 
  echo "Theme \"$THEME\" is invalid."
  exit 1
fi

# generate pixmaps from svg source
SRC=$PWD/src

create "$THEME-svg"

