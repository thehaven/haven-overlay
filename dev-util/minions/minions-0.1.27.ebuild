# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bun

DESCRIPTION="Mission Control — AI agent orchestration dashboard with fleet management"
HOMEPAGE="https://github.com/Agent-3-7/minions"
SRC_URI="https://github.com/Agent-3-7/minions/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox test strip"

S="${WORKDIR}/minions-${PV}"

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

pkg_postinst() {
	einfo "Minions (Mission Control) installed."
	einfo "Start: cd /usr/$(get_libdir)/node_modules/minions && node dist/server/server/index.js"
	einfo "Web UI: http://localhost:6969"
}
