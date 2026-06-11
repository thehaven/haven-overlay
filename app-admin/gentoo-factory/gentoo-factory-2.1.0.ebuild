# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="A declarative Gentoo build orchestrator with plugin engine"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/gentoo/gentoo-factory"
SRC_URI="https://gitlab-ee.thehavennet.org.uk/gentoo/gentoo-factory/-/archive/v${PV}/gentoo-factory-v${PV}.tar.gz"
S="${WORKDIR}/gentoo-factory-v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/docker[${PYTHON_USEDEP}]
	dev-python/pluggy[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-bdd[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
