# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="Run commands, capture output, handle errors"
HOMEPAGE="https://github.com/fmoo/python-runs"
# Stable PyPI "source" redirect keeps the URL version-parametric.
SRC_URI="https://files.pythonhosted.org/packages/source/r/runs/runs-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/uv-build[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
