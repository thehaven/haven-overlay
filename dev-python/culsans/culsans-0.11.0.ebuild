# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="culsans"

inherit distutils-r1 pypi

DESCRIPTION="Thread-safe async-aware queue for Python"
HOMEPAGE="
	https://github.com/x42005e1f/culsans
	https://pypi.org/project/culsans/
"
SRC_URI="https://files.pythonhosted.org/packages/source/c/culsans/culsans-${PV}.tar.gz"
S="${WORKDIR}/culsans-${PV}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# culsans has no required runtime deps; only typing-extensions
# (python<3.13) and aiologic are referenced via [dependency-groups]
# and optional extras, not core deps.

BDEPEND="
	dev-python/hatch-vcs
	dev-python/hatchling
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
