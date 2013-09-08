# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/targetcli/targetcli-9999.ebuild,v 1.3 2012/05/25 16:43:55 alexxy Exp $

EAPI=4

#EGIT_REPO_URI="git://linux-iscsi.org/${PN}.git"
EGIT_REPO_URI="git://github.com/agrover/targetcli-fb.git"
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"
SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils git-2 python linux-info

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
	"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~TARGET_CORE"

pkg_setup() {
	linux-info_pkg_setup
	python_pkg_setup
}
