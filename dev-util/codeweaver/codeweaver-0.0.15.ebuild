# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Weave a codebase into a single, navigable Markdown document"
HOMEPAGE="https://github.com/tesserato/CodeWeaver"
SRC_URI="https://github.com/tesserato/CodeWeaver/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

# Tag tarball extracts to CodeWeaver-${PV}/ (capital C); the default
# ${WORKDIR}/${P} would point at codeweaver-${PV} and fail.
S="${WORKDIR}/CodeWeaver-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Upstream does not ship a vendor/ directory, so module download must be
# permitted at build time. RESTRICT="network-sandbox" OPENS network for the
# package (it disables the default global sandbox for this ebuild only).
RESTRICT="network-sandbox test"

src_compile() {
	CGO_ENABLED=0 ego build -ldflags "-s -w" -o ${PN} .
}

src_install() {
	dobin ${PN}
	einstalldocs
}
