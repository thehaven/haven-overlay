# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Distillation and quantization toolkit for language models"
HOMEPAGE="https://pypi.org/project/distil/"
SRC_URI="https://github.com/voidful/Distil/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
S="${WORKDIR}/${P}"
KEYWORDS="~amd64"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	dev-python/torch[${PYTHON_USEDEP}]
	dev-python/transformers[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" -m unittest discover -s tests || die "Tests failed with ${EPYTHON}"
}

pkg_postinst() {
	einfo "Distil installed successfully!"
	einfo ""
	einfo "Distil is a distillation and quantization toolkit for language models."
	einfo "It provides tools for model compression, quantization, and optimization."
	einfo ""
	einfo "Features:"
	einfo "  - Model distillation techniques"
	einfo "  - Quantization methods"
	einfo "  - Model compression"
	einfo "  - Performance optimization"
	einfo ""
	einfo "For more information, see the project documentation at:"
	einfo "  https://github.com/voidful/Distil"
}
