# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
PYPI_PN="lance_namespace_urllib3_client"

inherit distutils-r1 pypi

DESCRIPTION="Lance Namespace Specification (urllib3 client implementation)"
HOMEPAGE="https://github.com/lancedb/lance-namespace"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Dependencies mirror lance-namespace-urllib3-client 0.3.2
# pyproject.toml [project].dependencies verbatim.
RDEPEND="
	>=dev-python/pydantic-2[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.7.1[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.25.3[${PYTHON_USEDEP}]
	<dev-python/urllib3-3.0.0
"

# Upstream test suite requires a running lance-namespace server.
RESTRICT="test"

