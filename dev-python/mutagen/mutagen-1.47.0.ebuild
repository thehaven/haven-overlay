# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="Python multimedia metadata reading and writing library"
HOMEPAGE="https://github.com/quodlibet/mutagen"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
