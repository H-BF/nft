SUBDIRS := $(shell find debian/* -maxdepth 0 -type d ! -name DEBIAN)
PKG_NAME := hbf-nft
GIT_LAST_TAG := $(shell git tag |tail -n 1 |cut -d "v" -f 2)
VERSION := $(or ${STRIPPED_VERSION},$(shell git describe --tags --exact-match 2> /dev/null | cut -d "v" -f 2))

ifeq ($(strip $(VERSION)),)
	VERSION=$(GIT_LAST_TAG)-$(shell git symbolic-ref -q --short HEAD || git rev-parse --short HEAD)
endif

.PHONY: all install clean

all:

install:
	fpm \
	-s dir -t deb \
	-p $(PKG_NAME)-$(VERSION)-any.deb \
	--name $(PKG_NAME) \
	--version $(VERSION) \
	--architecture deb \
	--description "nftables command line utility that support ndpi." \
	--maintainer "Kalashnikov V. kalashnikov.v24@wb.ru" \
	--after-install ./after-install.sh \
	./debian/opt/hbf=/opt/
clean:
	rm -rf *.deb
	rm -rf $(SUBDIRS)
