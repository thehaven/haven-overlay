# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# Resurrected from ::gentoo (treecleaned 2020-12-28, bug 668708/716268/731090):
# the wez fork moved from bitbucket autotools snapshots to GitHub CMake
# releases; audio tools like audiobook-forge hard-require the AtomicParsley
# binary at runtime.

MY_PN="atomicparsley"
# Full upstream tag is 20240608.083822.1ed9031; the hash component does not
# parse as a Portage version, so it is dropped from PV.
MY_TAG="20240608.083822.1ed9031"

DESCRIPTION="Reads, parses and sets iTunes-style metadata in MPEG4 files"
HOMEPAGE="https://github.com/wez/atomicparsley"
SRC_URI="https://github.com/wez/atomicparsley/archive/${MY_TAG}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_PN}-${MY_TAG}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="virtual/zlib"
DEPEND="${RDEPEND}"

DOCS=(Changes.txt README.md)

src_install() {
	dobin "${BUILD_DIR}/AtomicParsley"
	einstalldocs
}
