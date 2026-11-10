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

BDEPEND=">=dev-lang/go-1.26.2"
RESTRICT="network-sandbox"

src_compile() {
	ego build -ldflags "-s -w" -o osv-scanner ./cmd/osv-scanner
	ego build -ldflags "-s -w" -o osv-reporter ./cmd/osv-reporter
}

src_test() {
	ego test ./...
}

src_install() {
	dobin osv-scanner osv-reporter
	einstalldocs
}
