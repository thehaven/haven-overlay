# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/rtslib/rtslib-9999.ebuild,v 1.2 2012/08/09 04:09:49 patrick Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
EGIT_REPO_URI="git://github.com/agrover/rtslib-fb.git"

inherit eutils distutils-r1 git-r3 python-r1

DESCRIPTION="RTSLib Community Edition for target_core_mod/ConfigFS"
HOMEPAGE="https://github.com/agrover/rtslib-fb"
SRC_URI=""

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
    !dev-python/rtslib
	dev-python/configobj
	dev-python/ipaddr
	dev-python/netifaces
	"
RDEPEND="${DEPEND}"

src_install() {
	distutils_src_install
	keepdir /var/target/fabric
	insinto /var/target/fabric
}
