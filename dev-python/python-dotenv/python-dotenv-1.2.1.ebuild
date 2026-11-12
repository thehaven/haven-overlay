# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="Read key-value pairs from a .env file and set them as environment variables"
HOMEPAGE="https://github.com/theskumar/python-dotenv"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
