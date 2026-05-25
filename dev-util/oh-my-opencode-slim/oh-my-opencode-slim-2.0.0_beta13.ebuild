# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Slim agent harness for OpenCode with TUI and CLI"
HOMEPAGE="https://github.com/alvinunreal/oh-my-opencode-slim"
SRC_URI="https://github.com/alvinunreal/oh-my-opencode-slim/archive/refs/tags/v${PV}.0-beta.13.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/oh-my-opencode-slim-${PV}.0-beta.13"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode net-libs/nodejs"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die
	bun run build || die
}

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r dist package.json
}

pkg_postinst() {
	einfo "oh-my-opencode-slim installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  { \"name\": \"${PN}\", \"src\": \"/usr/lib/node_modules/${PN}/dist/cli/index.js\" }"
}
