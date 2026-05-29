# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit python-r1

DESCRIPTION="Patched Playwright — Chromium browser automation (anti-detection fork)"
HOMEPAGE="https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-python"
SRC_URI="
	amd64? ( https://files.pythonhosted.org/packages/dc/0e/37b7dd4b0e7db24148fb3fcc73ccb36d9c82a3f5c7c8300c45ed8a76b7f4/${P}-py3-none-manylinux1_x86_64.whl )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	>=dev-python/pyee-13[${PYTHON_USEDEP}]
	>=dev-python/greenlet-3.1.1[${PYTHON_USEDEP}]
"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	mkdir -p "${S}" || die
	unzip -qo "${DISTDIR}/${P}-py3-none-manylinux1_x86_64.whl" -d "${S}" || die
}

src_install() {
	cd "${S}" || die
	python_foreach_impl python_install
}

python_install() {
	python_domodule patchright
}
