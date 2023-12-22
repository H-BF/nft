#!/bin/bash

PKG_DIR=$(pwd)/packages/deb
INSTALL_DIR=$PKG_DIR/debian/opt/swarm/

function clean() {
  make -C $PKG_DIR clean
  make clean
  make distclean
}

function configure() {
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/swarm/lib/pkgconfig/
  ./autogen.sh
  ./configure --prefix=$INSTALL_DIR --with-pkgdst=/opt/swarm --with-json
}

function build() {
  make all
  make install
  make -C $PKG_DIR install
}

clean
set -e
configure
build

echo "Build successful! Check: $PKG_DIR"
