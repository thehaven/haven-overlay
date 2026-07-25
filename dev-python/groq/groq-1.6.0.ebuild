# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="groq"
inherit distutils-r1 pypi

DESCRIPTION="The official Python library for the groq API"
HOMEPAGE="https://github.com/groq/groq-python"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/httpx-0.27[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.10[${PYTHON_USEDEP}]
	>=dev-python/anyio-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/distro-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/sniffio-1.1[${PYTHON_USEDEP}]
"
