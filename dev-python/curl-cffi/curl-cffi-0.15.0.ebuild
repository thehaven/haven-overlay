# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 pypi

DESCRIPTION="libcurl ffi bindings for Python, with impersonation support"
HOMEPAGE="https://github.com/yifeikong/curl_cffi"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/cffi[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	net-misc/curl
"
DEPEND="${RDEPEND}"
