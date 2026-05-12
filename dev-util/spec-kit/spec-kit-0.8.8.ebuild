# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="GitHub Spec Kit CLI (specify)"
HOMEPAGE="https://github.com/github/spec-kit"
SRC_URI="https://github.com/github/spec-kit/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/click-8.1[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.20.0[${PYTHON_USEDEP}]
	dev-python/httpx-socks[${PYTHON_USEDEP}]
	>=dev-python/json5-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-23.0[${PYTHON_USEDEP}]
	>=dev-python/pathspec-0.12.0[${PYTHON_USEDEP}]
	dev-python/platformdirs[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
	dev-python/readchar[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	>=dev-python/truststore-0.10.4[${PYTHON_USEDEP}]
	dev-python/typer[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
