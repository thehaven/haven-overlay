# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Render markdown on the CLI, with pizzazz"
HOMEPAGE="https://github.com/charmbracelet/glow"
SRC_URI="https://github.com/charmbracelet/glow/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Upstream does not ship a vendor/ directory, so module download must be
# permitted at build time. RESTRICT="network-sandbox" OPENS network for the
# package (it disables the default global sandbox for this ebuild only).
RESTRICT="network-sandbox test"

# go.mod declares go 1.26.5; bump the eclass default of 1.24.11 to match.
BDEPEND=">=dev-lang/go-1.26.5"

src_compile() {
	CGO_ENABLED=0 ego build -ldflags "-s -w" -o ${PN} .
}

src_install() {
	dobin ${PN}
	einstalldocs
}
