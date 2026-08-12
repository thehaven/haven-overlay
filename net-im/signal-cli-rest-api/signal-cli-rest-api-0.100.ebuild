# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="REST API wrapper for signal-cli (Signal Messenger)"
HOMEPAGE="https://github.com/bbernhard/signal-cli-rest-api"
SRC_URI="https://github.com/bbernhard/signal-cli-rest-api/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# The Go module lives in src/; the repository root also carries
# container-only assets (ext/libsignal-client builds, Dockerfile).
S="${WORKDIR}/${P}/src"

# Runtime: invokes the signal-cli binary from PATH for every request
# (normal/json-rpc modes) with -signal-cli-config.
RDEPEND="
	net-im/signal-cli
"

# No vendor tarball: MUST declare RESTRICT="network-sandbox" (network
# ALLOWED) so `go` can download modules; a vendor tarball build would
# omit it and stay offline.
RESTRICT="network-sandbox"

src_compile() {
	ego build -ldflags "-s -w" -o "${PN}" . || die
}

src_install() {
	dobin "${PN}"
	einstalldocs
}

pkg_postinst() {
	einfo "${PN} ${PV}: REST API wrapper for signal-cli"
	einfo "Binary: /usr/bin/signal-cli-rest-api"
	einfo ""
	einfo "Run with a dedicated signal-cli config dir:"
	einfo "  signal-cli-rest-api -signal-cli-config=/var/lib/signal-cli"
	einfo ""
	einfo "Register a number first:"
	einfo "  signal-cli --config /var/lib/signal-cli register +<number>"
}
