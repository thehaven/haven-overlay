# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

# pypdfium2 5.x sdist build downloads prebuilt pdfium binaries from the
# pypdfium2-team/pdfium-binaries release at build time (via the `gh` CLI
# inside setup.py::setupsrc/update.py) and either runs ctypesgen to
# regenerate the C bindings or falls back to bundled reference bindings.
# This requires network during src_compile and the dev-libs/libffi-style
# toolchain (gcc, cmake). The prebuilt wheels on PyPI exist for
# production deployments but a source-based overlay build is the
# prescribed path.
inherit distutils-r1 pypi

DESCRIPTION="Python bindings for the PDFium rendering library (pure-Python + ctypes)"
HOMEPAGE="
	https://github.com/pypdfium2-team/pypdfium2
	https://pypi.org/project/pypdfium2/
"
SRC_URI="https://files.pythonhosted.org/packages/source/p/pypdfium2/pypdfium2-${PV}.tar.gz"
S="\${WORKDIR}/\${P}"

LICENSE="Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Network access is required during src_compile to download the
# prebuilt pdfium binary matching the target arch. The build will
# fail under the network sandbox otherwise.
RESTRICT="network-sandbox"

BDEPEND="
	dev-build/cmake
	sys-devel/gcc
	>=dev-lang/python-3.12
"

# No runtime Python deps (uses stdlib ctypes).
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

pkg_postinst() {
	elog "pypdfium2 builds against the prebuilt pdfium binary"
	elog "downloaded from github.com/pypdfium2-team/pdfium-binaries"
	elog "during src_compile. Ensure the build host has network"
	elog "access and dev-build/cmake + sys-devel/gcc installed."
}
