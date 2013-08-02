# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"
SUPPORT_PYTHON_ABIS="1"

inherit distutils git-2

DESCRIPTION="a small server for collecting and translating metrics for Graphite"
HOMEPAGE="https://github.com/cloudant/bucky"
EGIT_REPO_URI="https://github.com/cloudant/bucky.git"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
