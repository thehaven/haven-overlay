# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-2

DESCRIPTION="Hiphop, converts php into c++"
HOMEPAGE="https://www.facebook.com/hphp"
EGIT_REPO_URI="https://github.com/facebook/hiphop-php.git"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-util/re2c
dev-cpp/glog
dev-cpp/tbb
virtual/mysql
>=dev-libs/boost-1.37
dev-libs/expat
>=dev-libs/jemalloc-3.0
>=dev-libs/icu-4.2
|| ( dev-libs/libdwarf dev-libs/elfutils )
dev-libs/libevent
dev-libs/libmcrypt
dev-libs/libmemcached
dev-libs/libpcre
dev-libs/libxml2
dev-libs/oniguruma
dev-libs/openssl
>=dev-util/cmake-2.6
media-libs/gd
net-misc/curl
net-libs/c-client
sys-devel/flex
>=sys-devel/gcc-4.3[cxx]
sys-devel/bison
sys-devel/binutils
sys-libs/libcap
sys-libs/libunwind
sys-libs/zlib"

RDEPEND="${DEPEND}"

export HPHP_HOME=${WORKDIR}/${P}
export HPHP_LIB=${WORKDIR}/${P}/bin
export CMAKE_PREFIX_PATH=${WORKDIR}/temp
