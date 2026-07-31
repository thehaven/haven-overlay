# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="An HTML Minifier"
HOMEPAGE="
	https://htmlmin.readthedocs.io/en/latest/
	https://github.com/wilhelmer/htmlmin
	https://pypi.org/project/htmlmin2/
"
SRC_URI="https://github.com/wilhelmer/htmlmin/archive/refs/tags/v${PV}.tar.gz -> htmlmin2-${PV}.gh.tar.gz"

S="${WORKDIR}/htmlmin-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="test"
RESTRICT="!test? ( test )"

distutils_enable_tests unittest
