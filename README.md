# NFTABLES WITH nDPI
This is a fork of the official [nftables](https://git.netfilter.org/nftables/) command line utility extended to support nftables rules with the [nDPI](https://gitlab-internal.wildberries.ru/swarm/swarm/ndpi) forked from the [netfilter ndpi](https://github.com/vel21ripn/nDPI).

## How To Compile
### Prerequisites:
  - build tooling: glibc headers, gcc, autotools, automake, libtool, pkg-config.

  - libmnl: git://git.netfilter.org/libmnl.git

  - [swarm-libnftnl](https://gitlab-internal.wildberries.ru/swarm/system/nftables/libnftnl)

  - flex

  - bison

  - libgmp: alternatively, see mini-gmp support below.

  - libreadline or libedit or linenoise: required by interactive command line

  - optional: libxtables: required to interact with iptables-compat

  - optional: libjansson: required to build JSON support

  - optional: asciidoc: required for building man-page

  - optional: [fpm](https://fpm.readthedocs.io/en/v1.15.1/index.html): required for building deb or rpm packages

### Configuring and compiling
 - Install [swarm-libnftnl](https://gitlab-internal.wildberries.ru/swarm/system/nftables/libnftnl) and all needed tools from the Prerequisites list
 - Run "sh autogen.sh" to generate the configure script

 - ./configure [options]

    --prefix=

        The prefix to put all installed files under. It defaults to
        /usr/local, so the binaries will go into /usr/local/bin, sbin,
        manpages into /usr/local/share/man, etc.

    --datarootdir=

	    The base directory for arch-independent files. Defaults to
	    $prefix/share.

    --disable-debug

	    Disable debugging

    --with-mini-gmp

	    Use builtin mini-gmp instead of linking with a shared libgmp.
	    This is useful for embedded platforms optimizing for size and
	    having no other use for libgmp.
	    Note: This decreases the debugging verbosity in some files.

    --with-xtables

	    For libxtables support to interact with the iptables-compat
	    utility.

    --without-cli

	    To disable interactive command line support, ie. -i/--interactive.

    --with-cli=readline

	    To enable interactive command line support with libreadline.

    --with-cli=linenoise

	    To enable interactive command line support with linenoise.

    --with-cli=editline

	    To enable interactive command line support with libedit.

    --with-json

	    To enable JSON support, this requires libjansson.

    --with-build-deb

	    To enable build with deb package

    --with-build-rpm

	    To enable build with rpm package

    --with-pkgdst=

	    Path where the package will be installed. By default all will be installed into path determinated by the --prefix option

 - Run "make" to compile nftables.
 - Run "make install" to install it in the configured paths.

        Note: Before running make you may need to determinate pkgconfig path for the libnftnl library installed early
        (e.g. export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/swarm/lib/pkgconfig/)

### Configuration with packages
 To enable build a package just configure one of the option:

	./configure --with-build-deb
	make build-deb
	or
	./configure --with-build-rpm
	make build-rpm
 If you need to install a package to a specific location
 you have to specify the path using the --with-pkgdst option:

	./configure --with-pkgdst=/opt/swarm/ --with-build-deb
	make build-deb

## How to use nftables with ndpi
Extended version of the nftables supports additional options to create rules that include nDPI features.

Rules with nDPI features have to begin with the keyword "ndpi". After it is possible to specify a few ndpi option:

 - proto - Match by L7 protocol or list of protocols, such as http, dns, smtp, ntp, pop3, etc..., or all available protocols by parameter "all"
 - host - Match by host name or fqdn that can be detected in the tcp stream or in  specified L7 protocols
 - untracked - Match if detection is not started for this connection
 - inprogress - Match if ptotocol detection in progress. Used with the option "proto"

        Note: The above options are available by using preloaded ndpi netfilter kernel module xt_ndpi.ko (See https://gitlab-internal.wildberries.ru/swarm/swarm/ndpi)

### Examples:
Before creating nftables rules with the ndpi options you should [install](https://gitlab-internal.wildberries.ru/swarm/swarm/ndpi)  and run the ndpi netfilter kernel module:

 - If the ndpi kernel module is still not running, run it:

        sudo modprobe xt_ndpi

        (Note: nf_conntrack and nf_tables modules must be installed)
 - If you need to update running ndpi kernel module, follow these steps:

   - remove all nftables rules with ndpi options: sudo nft flush ruleset
   - clean conntrack table: sudo conntrack -F
   - remove old ndpi kernel module: sudo rmmod xt_ndpi
   - run new ndpi kernel module:  sudo modprobe xt_ndpi

Some examples how to create nftables rules with the ndpi options:
1. Rule for blocking access to the example2.com website via the HTTP protocol:
   
   - nft add table ip test
   - nft add chain test test \{ type filter hook postrouting priority 0\; \}
   - nft add rule ip test test ndpi proto http host example2.com counter drop
2. Rule from file:
   
        table inet filter {
            chain input {
                type filter hook input priority filter; policy accept;
            }

            chain forward {
                type filter hook forward priority filter; policy accept;
            }

            chain output {
                type filter hook output priority filter; policy accept;
                        ndpi proto http inprogress counter packets 0 bytes 0 accept
                        ndpi host youtube.com proto "dns,http" counter packets 0 bytes 0 accept
                        ct state established,related counter packets 0 bytes 0 accept
            }
        }
