# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="Mozilla's CA Bundle (curated by certifi) for use with TLS/SSL"
HOMEPAGE="https://github.com/certifi/python-certifi"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
