# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )
inherit distutils-r1

DESCRIPTION="A vector search extension for SQLite"
HOMEPAGE="https://github.com/asg017/sqlite-vec"
# Using the manylinux wheel as the source since upstream doesn't provide a clean sdist on PyPI
# and the build process from GitHub is complex (requires C + vendored deps).
# This is a binary ebuild.
SRC_URI="
	amd64? ( https://files.pythonhosted.org/packages/6f/ad/6afd073b0f817b3e03f9e37ad626ae341805891f23c74b5292818f49ac63/sqlite_vec-0.1.9-py3-none-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux1_x86_64.whl -> ${P}-amd64.whl )
	arm64? ( https://files.pythonhosted.org/packages/00/d4/f2b936d3bdc38eadcbd2a87875815db36430fab0363182ba5d12cd8e0b51/sqlite_vec-0.1.9-py3-none-manylinux_2_17_aarch64.manylinux2014_aarch64.whl -> ${P}-arm64.whl )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="dev-db/sqlite:3"
BDEPEND="dev-python/gpep517[${PYTHON_USEDEP}]"

S="${WORKDIR}"

python_install() {
	unzip -o "${DISTDIR}/${PN}-${PV}-${ARCH}.whl" -d "${D}/$(python_get_sitedir)" || die
}
