# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A kerberos KDC HTTP proxy WSGI module"
HOMEPAGE="https://github.com/latchset/kdcproxy"
SRC_URI="https://github.com/latchset/kdcproxy/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	${PYTHON_DEPS}
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
