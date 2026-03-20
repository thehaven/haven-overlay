# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Interactive curses-based port and process viewer"
HOMEPAGE="https://github.com/sunels/heimdall"
SRC_URI="https://github.com/sunels/heimdall/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	sys-apps/witr
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/patches/consolidated-improvements.patch"
)

distutils_enable_tests pytest

src_prepare() {
	einfo "Applying Haven't-standard security, performance, and UX fixes..."
	default
}

src_install() {
	distutils-r1_src_install

	insinto /etc/heimdall
	newins "${FILESDIR}/heimdall.env" heimdall.env
}
