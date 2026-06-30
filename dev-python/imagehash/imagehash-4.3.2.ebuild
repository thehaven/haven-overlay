# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1

DESCRIPTION="Image hashing library written in pure Python"
HOMEPAGE="https://github.com/JohannesBuchner/imagehash"
# ImageHash is capital-I on PyPI; pypi_sdist_url would emit the wrong
# case, so pin the URL directly.
SRC_URI="https://files.pythonhosted.org/packages/cd/de/5c0189b0582e21583c2a213081c35a2501c0f9e51f21f6a52f55fbb9a4ff/ImageHash-${PV}.tar.gz"

LICENSE="BSD-2-Clause"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pywavelets[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
