pkgname="lyra-cursors"
pkgver="1.0.0"
pkgrel=1
pkgdesc="An x-cursor theme inspired by macOS and
based on [capitaine-cursors](https://github.com/keeferrourke/capitaine-cursors)."
arch=("any")
url="https://github.com/yeyushengfan258/Lyra-Cursors"
makedepends=("xorg-xcursorgen" "inkscape")
license=("GPL3")
# source=("")
# sha512sums=("SKIP")

build() {

THEMENAMES="
LyraB
LyraF
LyraG
LyraP
LyraQ
LyraR
LyraS
LyraX
LyraY
"

  for THEME in $THEMENAMES; do
    cd $srcdir/../
    $srcdir/../build.sh $THEME
  done
}

package() {
  # Destination directory
  DEST_DIR="$pkgdir/usr/share/icons"
  mkdir -p $DEST_DIR
  cp -pr $srcdir/../dist/*-cursors $DEST_DIR/
}
