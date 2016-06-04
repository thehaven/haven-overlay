# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools eutils multilib prefix user

KEYWORDS="~amd64 ~x86"

SLOT="1"
DESCRIPTION="An open-source distributed database built with love."
HOMEPAGE="http://www.rethinkdb.com"
SRC_URI="http://download.rethinkdb.com/dist/${PF}.tgz"
LICENSE="AGPL-3"

# need to add this for various builds:
# a. with/out tcmalloc_minimal
# b. precompiled assets?
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
	dev-libs/boost
	dev-libs/jemalloc
	dev-libs/openssl
	dev-libs/protobuf
	dev-libs/protobuf-c
	dev-util/google-perftools
	net-misc/curl
	sys-devel/gcc
	sys-libs/ncurses
	virtual/jre
	"

# and npm, less, handlebars, coffee

pkg_setup() {
	enewgroup rethinkdb 71
	enewuser rethinkdb 71 /bin/bash /var/lib/rethinkdb rethinkdb
}

src_configure() {
	./configure --allow-fetch --prefix=/usr --sysconfdir=/etc --localstatedir=/usr/var termcap=-lncurses
}

src_install() {
	emake STRIP_ON_INSTALL=0 DESTDIR="${D}" install
	dodoc COPYRIGHT NOTES.md README.md
}
