# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
PYPI_PN="lance_namespace"

inherit distutils-r1 pypi

DESCRIPTION="Lance Namespace interface and plugin registry"
HOMEPAGE="https://github.com/lancedb/lance-namespace"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Pin the urllib3 client plugin to the exact 0.3.2 release to match
# the lance-namespace 0.3.2 interface version. Bump together.
RDEPEND="
	=dev-python/lance-namespace-urllib3-client-0.3.2*
"

# Upstream test suite requires a running lance-namespace server.
RESTRICT="test"
