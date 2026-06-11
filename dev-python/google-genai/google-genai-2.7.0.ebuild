# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

src_prepare() {
	distutils-r1_src_prepare

	# pyproject.toml is missing build-backend
	sed -i "/\[build-system\]/a build-backend = \"setuptools.build_meta\"" pyproject.toml || die
}

DESCRIPTION="GenAI Python SDK — Google's Generative AI client library"
HOMEPAGE="https://github.com/googleapis/python-genai"
SRC_URI="https://github.com/googleapis/python-genai/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/python-genai-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/anyio-4.8.0[${PYTHON_USEDEP}]
	>=dev-python/google-auth-2.48.1[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.28.1[${PYTHON_USEDEP}]
	>=dev-python/tenacity-8.2.3[${PYTHON_USEDEP}]
	>=dev-python/websockets-13.0.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.14.0[${PYTHON_USEDEP}]
	>=dev-python/distro-1.7.0[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
"
# NOTE: Upstream requires google-auth>=2.48.1; portage has 2.47.0.
# google-auth[requests] extra satisfied by explicit dev-python/requests RDEPEND.

BDEPEND="
	test? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
