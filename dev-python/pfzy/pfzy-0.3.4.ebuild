# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1

DESCRIPTION="Python port of fzy — fast fuzzy string matching algorithm"
HOMEPAGE="https://github.com/kazhala/pfzy"
SRC_URI="https://github.com/kazhala/pfzy/archive/${PV}.tar.gz -> pfzy-${PV}.tar.gz"
S="${WORKDIR}/pfzy-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
BDEPEND="
	dev-python/poetry-core[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
