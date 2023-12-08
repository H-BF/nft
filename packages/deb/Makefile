SUBDIRS := $(shell find debian/* -maxdepth 0 -type d ! -name DEBIAN)
PKG_NAME := nft
PKG_VER := $(STRIPPED_VERSION)

.PHONY: all install clean

all:

install:
	fpm \
	-s dir -t deb \
	-p hbf-nft-$(STRIPPED_VERSION)-any.deb \
	--name hbf-nft \
	--version $(STRIPPED_VERSION) \
	--architecture all \
	--description "nftables command line utility that support ndpi." \
	--maintainer "Kalashnikov V. kalashnikov.v24@wb.ru" \
	--after-install ./after-install.sh \
	./debian/opt/hbf=/opt/
clean:
	rm -rf *.deb
	rm -rf $(SUBDIRS)
