# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_D="opencode-plugin-safety-net-node_modules-0.9.0"

DESCRIPTION="Safety net catching destructive git and filesystem commands for OpenCode"
HOMEPAGE="https://github.com/kenryu42/claude-code-safety-net"
SRC_URI="
	https://github.com/kenryu42/claude-code-safety-net/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/${MY_NODE_D}.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="
	dev-nodejs/opencode-ai-plugin
	dev-nodejs/shell-quote
	dev-nodejs/typescript
"

S="${WORKDIR}/claude-code-safety-net-${PV}"

src_compile() {
	bun run build || die
}

src_install() {
	dobin dist/bin/cc-safety-net.js
}

pkg_postinst() {
	einfo "OpenCode CC Safety Net plugin installed."
	einfo "To enable, add to opencode.json:"
	einfo "  \"/usr/bin/cc-safety-net.js\""
}
