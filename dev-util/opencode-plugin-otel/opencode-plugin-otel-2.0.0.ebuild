# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bun

DESCRIPTION="OpenCode plugin for exporting telemetry via OpenTelemetry"
HOMEPAGE="https://github.com/DEVtheOPS/opencode-plugin-otel"
SRC_URI="https://github.com/DEVtheOPS/opencode-plugin-otel/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/opencode-plugin-otel-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test strip"

RDEPEND="dev-util/opencode"

src_compile() {
	# Source-based deps (replaces the former MY_NODE_D mirror tarball).
	rm -f package-lock.json
	bun install --ignore-scripts || die "bun install failed"
	bun run build || die "bun run build failed"
}

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json node_modules
}
