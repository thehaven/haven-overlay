# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Vulnerability scanner written in Go which uses data from https://osv.dev"
HOMEPAGE="https://github.com/google/osv-scanner"
SRC_URI="https://github.com/google/osv-scanner/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# This ebuild is a skeleton. Real Go ebuilds need EGO_SUM or a vendor tarball.
# We will attempt to generate it.
