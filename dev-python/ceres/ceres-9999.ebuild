# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5,3_6} )

inherit distutils-r1 eutils git-r3

DESCRIPTION="Distributable time-series database"
HOMEPAGE="https://github.com/graphite-project/ceres"
EGIT_REPO_URI="https://github.com/graphite-project/ceres.git"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

pkg_postinst() {
	einfo "Initialise the ceres database using:"
	einfo "ceres-tree-create /opt/graphite/storage/ceres"
}
