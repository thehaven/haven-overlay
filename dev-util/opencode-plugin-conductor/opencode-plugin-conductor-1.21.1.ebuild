# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin for multi-agent task dispatch"
HOMEPAGE="https://github.com/derekbar90/opencode-conductor"
SRC_URI="https://github.com/derekbar90/opencode-conductor/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/opencode-conductor-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="network-sandbox test"

inherit bun

RDEPEND="dev-util/opencode"

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json

	dodoc README.md
}
