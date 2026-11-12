# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1
distutils_enable_tests pytest

DESCRIPTION="Professional Node.js to Gentoo Ebuild generator"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/gentoo/npm2ebuild"
SRC_URI="https://gitlab-ee.thehavennet.org.uk/gentoo/npm2ebuild/-/archive/main/npm2ebuild-main.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"

S="${WORKDIR}/npm2ebuild-main"
