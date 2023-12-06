#!/bin/bash

PRG_PREFIX := hbf

PKG_DIR=$(pwd)/packages/deb
INSTALL_DIR=$PKG_DIR/debian/opt/hbf/

function clean() {
  make -C $PKG_DIR clean
  make clean
  make distclean
}

function configure() {
  ./autogen.sh
  ./configure --prefix=$INSTALL_DIR --program-prefix=$PRG_PREFIX --with-json
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