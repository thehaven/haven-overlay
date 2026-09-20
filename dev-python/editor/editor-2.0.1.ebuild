# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="Programmatically open an editor, capture the result"
HOMEPAGE="https://github.com/fmoo/python-editor"
# Stable PyPI "source" redirect keeps the URL version-parametric.
SRC_URI="https://files.pythonhosted.org/packages/source/e/editor/editor-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/hatchling[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
