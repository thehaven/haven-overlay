# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="Collection of common interactive command line user interfaces"
HOMEPAGE="https://github.com/magmax/python-inquirer"
# Stable PyPI "source" redirect keeps the URL version-parametric (the
# hash-path form breaks on every bump). The former ebuild pointed at
# kazhala/InquirerPy, a different package that cannot satisfy the
# >=3.4.0 requirement of dev-util/mcp-server-linkedin.
SRC_URI="https://files.pythonhosted.org/packages/source/i/inquirer/inquirer-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/blessed-1.19.0[${PYTHON_USEDEP}]
	>=dev-python/readchar-4.2.0[${PYTHON_USEDEP}]
"
# NOTE: upstream also requires dev-python/editor (the "editor" prompt type),
# but it is absent from the frozen ::gentoo tree on this host; the core
# prompt types (text/confirm/list/checkbox) do not need it.
BDEPEND="
	dev-python/poetry-core[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
