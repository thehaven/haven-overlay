# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/haproxy/haproxy-1.4.21.ebuild,v 1.4 2012/06/08 18:06:38 ranger Exp $

EAPI="4"

inherit eutils versionator toolchain-funcs flag-o-matic

PF_MY=${PF/-r/-dev}

DESCRIPTION="A TCP/HTTP reverse proxy for high availability environments"
HOMEPAGE="http://haproxy.1wt.eu"
SRC_URI="http://haproxy.1wt.eu/download/$(get_version_component_range 1-2)/src/devel/${PF_MY}.tar.gz"
S="/var/tmp/portage/net-proxy/${PF}/work/${PF_MY}"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="examples kernel_linux pcre ssl tfo zlib vim-syntax"

DEPEND="pcre? ( dev-libs/libpcre )"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup haproxy
	enewuser haproxy -1 -1 -1 haproxy
}

src_compile() {
	local args="TARGET=linux2628"
	local args="${args} CPU=native"

	use pcre && args="${args} USE_PCRE=1" 
    use ssl && args="${args} USE_OPENSSL=1"
	use tfo && args="${args} USE_TFO=1"
	use zlib && args="${args} USE_ZLIB=1"

	use kernel_linux && args="${args} USE_LINUX_SPLICE=1"
	use kernel_linux && args="${args} USE_LINUX_TPROXY=1"

	# For now, until the strict-aliasing breakage will be fixed
	append-cflags -fno-strict-aliasing

	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) ${args} || die
}

src_install() {
	dobin haproxy || die

	newinitd "${FILESDIR}/haproxy.initd-r1" haproxy || die

	# Don't install useless files
	rm examples/build.cfg doc/*gpl.txt

	dodoc CHANGELOG ROADMAP TODO doc/{configuration,haproxy-en}.txt
	doman doc/haproxy.1

	if use examples;
	then
		docinto examples
		dodoc examples/*.cfg || die
	fi

	if use vim-syntax;
	then
		insinto /usr/share/vim/vimfiles/syntax
		doins examples/haproxy.vim || die
	fi
}

pkg_postinst() {
	if [[ ! -f "${ROOT}/etc/haproxy.cfg" ]] ; then
		ewarn "You need to create /etc/haproxy.cfg before you start the haproxy service."
		ewarn "It's best practice to not run haproxy as root, user and group haproxy was therefore created."
		ewarn "Make use of them with the \"user\" and \"group\" directives."

		if [[ -d "${ROOT}/usr/share/doc/${PF}" ]]; then
			einfo "Please consult the installed documentation for learning the configuration file's syntax."
			einfo "The documentation and sample configuration files are installed here:"
			einfo "   ${ROOT}usr/share/doc/${PF}"
		fi
		if use ssl; then
			einfo "For a useful guide on configuring SSL for HAProxy follow:"
			einfo "http://tinyurl.com/8ah26ht"
		fi
	fi
}
