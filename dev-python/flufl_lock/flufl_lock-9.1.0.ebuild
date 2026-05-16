# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_PN="flufl.lock"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1 pypi

DESCRIPTION="NFS-safe file locking with timeouts"
HOMEPAGE="https://gitlab.com/warsaw/flufl.lock"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
