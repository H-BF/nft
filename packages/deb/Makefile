SUBDIRS := $(shell find debian/* -maxdepth 0 -type d ! -name DEBIAN)
PKG_NAME := swarm-nft
GIT_LAST_TAG := $(shell git tag |tail -n 1 |cut -d "v" -f 2)
VERSION := $(or ${STRIPPED_VERSION},$(shell git describe --tags --exact-match 2> /dev/null | cut -d "v" -f 2))
LIBNFTNL_GIT_LAST_TAG := $(shell git submodule --quiet foreach git tag |tail -n 1 |cut -d "-" -f 2)
LIBNFTNL_VERSION := $(or ${STRIPPED_VERSION},$(shell git submodule --quiet foreach git describe --tags --exact-match 2> /dev/null | cut -d "-" -f 2))

LIB_DIR := $(CURDIR)/debian/opt/swarm

ifeq ($(strip $(VERSION)),)
	VERSION=$(GIT_LAST_TAG)-$(shell git symbolic-ref -q --short HEAD || git rev-parse --short HEAD)
endif

ifeq ($(strip $(LIBNFTNL_VERSION)),)
	LIBNFTNL_VERSION=$(LIBNFTNL_GIT_LAST_TAG)-$(shell git submodule --quiet foreach git symbolic-ref -q --short HEAD || git rev-parse --short HEAD)
endif

.PHONY: all install clean

all:

install:
	fpm \
	-s dir -t deb \
	-p $(PKG_NAME)-$(VERSION)-any.deb \
	-d libmnl-dev \
	-d flex \
	-d bison \
	-d libgmp-dev \
	-d libedit-dev \
	-d libjansson-dev \
	-d libnftables-dev \
	-d swarm-libnftnl > ${LIBNFTNL_VERSION} \
	--name $(PKG_NAME) \
	--version $(VERSION) \
	--architecture all \
	--description "nftables command line utility that support ndpi." \
	--maintainer "Kalashnikov V. kalashnikov.v24@wb.ru" \
	$(LIB_DIR)=/opt/
clean:
	rm -rf *.deb
	rm -rf $(SUBDIRS)
