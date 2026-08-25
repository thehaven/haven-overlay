# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Command line client for speedtest.net, written in Go"
HOMEPAGE="https://github.com/showwin/speedtest-go"
SRC_URI="https://github.com/showwin/speedtest-go/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# No vendor tarball: MUST declare RESTRICT="network-sandbox" (network
# ALLOWED) so `go` can download modules; a vendor tarball build would
# omit it and stay offline.
RESTRICT="network-sandbox"

src_compile() {
	# Upstream's goreleaser injects main.commit (short git hash) and
	# main.date (build time); version is a hardcoded constant in the
	# speedtest package and cannot be overridden. The source tarball has
	# no git metadata, so commit falls back to the PV and date to the
	# build timestamp.
	ego build -ldflags "-s -w -X main.commit=${PV} -X main.date=$(date -u +%Y%m%d)" \
		-o "${PN}" . || die
}

src_install() {
	dobin "${PN}"
	einstalldocs
}
