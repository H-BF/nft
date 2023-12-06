SUBDIRS := $(shell find debian/* -maxdepth 0 -type d ! -name DEBIAN)
PKG_NAME := nft
PKG_VER := $(shell git tag |tail -n 1)

.PHONY: all install clean

all:

install:
	dpkg-deb --build debian $(PKG_NAME)-$(PKG_VER).deb || exit 1

clean:
	rm -rf *.deb
	rm -rf $(SUBDIRS)