EAPI=8
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..14} )
# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..14} )
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="jsonschema-rs"
inherit distutils-r1 pypi

DESCRIPTION="jsonschema-rs Python package"
HOMEPAGE="https://github.com/Stranger6667/jsonschema/tree/master/crates/jsonschema-py"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="

"
