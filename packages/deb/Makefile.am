LIB_DIR=$(CURDIR)/../content/

if BUILD_DEB
build-deb:
	fpm \
	-s dir -t deb \
	-p $(PKG_NAME)-$(PKG_VERSION)-any.deb \
	-d libmnl-dev \
	-d flex \
	-d bison \
	-d libgmp-dev \
	-d libedit-dev \
	-d libjansson-dev \
	-d libnftables-dev \
	-d swarm-libnftnl > ${LIBNFTNL_VERSION} \
	--name $(PKG_NAME) \
	--version $(PKG_VERSION) \
	--architecture all \
	--description "nftables command line utility that support ndpi." \
	--maintainer "Kalashnikov V. kalashnikov.v24@wb.ru" \
	$(LIB_DIR)=$(pkgdst)

clean-deb:
	rm -rf *.deb
	rm -rf ${LIBNFTNL_VERSION}

endif

