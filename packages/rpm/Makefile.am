LIB_DIR=$(CURDIR)/../content/

if BUILD_RPM
build-rpm:
	fpm \
	-s dir -t rpm \
	-p $(PKG_NAME)-$(PKG_VERSION)-any.rpm \
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

clean-rpm:
	rm -rf *.rpm
	rm -rf ${LIBNFTNL_VERSION}

endif
