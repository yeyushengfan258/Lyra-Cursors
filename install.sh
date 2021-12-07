#!/bin/bash

ROOT_UID=0
DEST_DIR=
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

if [ ! -d "dist" ]; then 
  echo "No dist directory found; run the build script first."
  exit 1
fi

if [ ! -d "dist/$THEME-cursors" ]; then 
  echo "Theme \"$THEME\" has not been built."
  exit 1
fi

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/icons"
else
  DEST_DIR="$HOME/.local/share/icons"
fi

if [ -d "$DEST_DIR/$THEME-cursors" ]; then
  rm -r "$DEST_DIR/$THEME-cursors"
fi

cp -pr dist/$THEME-cursors $DEST_DIR/$THEME-cursors

echo "Finished..."

