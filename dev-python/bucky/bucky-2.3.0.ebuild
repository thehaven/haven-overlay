# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="a small server for collecting and translating metrics for Graphite"
HOMEPAGE="https://github.com/cloudant/bucky"
EGIT_REPO_URI="https://github.com/cloudant/bucky.git"
EGIT_COMMIT="0.1.0"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="runit"

DEPEND=""
RDEPEND="${DEPEND}
		runit? ( sys-process/runit )
"
