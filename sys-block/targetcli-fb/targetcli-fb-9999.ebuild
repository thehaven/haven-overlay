# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/targetcli/targetcli-9999.ebuild,v 1.3 2012/05/25 16:43:55 alexxy Exp $

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

#EGIT_REPO_URI="git://linux-iscsi.org/${PN}.git"
EGIT_REPO_URI="git://github.com/agrover/targetcli-fb.git"

inherit eutils distutils-r1 git-r3 python-r1 linux-info

DESCRIPTION="The targetcli-fb administration shell"
HOMEPAGE="https://github.com/agrover/targetcli-fb"
SRC_URI=""

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-python/configshell
	!dev-python/rtslib
	dev-python/rtslib-fb
	sys-apps/ethtool
	dev-python/python-ethtool
	dev-python/six
	"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~TARGET_CORE"

pkg_setup() {
	linux-info_pkg_setup
	python_pkg_setup
}
