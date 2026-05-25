# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_D="oh-my-opencode-slim-node_modules-2.0.0-beta.13"

DESCRIPTION="Slim agent harness for OpenCode with TUI and CLI"
HOMEPAGE="https://github.com/alvinunreal/oh-my-opencode-slim"
SRC_URI="
	https://github.com/alvinunreal/${PN}/archive/refs/tags/v${PV/_beta/-beta.}.tar.gz -> ${P}.tar.gz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/${MY_NODE_D}.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"

S="${WORKDIR}/${PN}-${PV/_beta/-beta.}"

src_compile() {
	# node_modules/ is at ${WORKDIR}/node_modules/ — Bun resolves by
	# walking up the directory tree from ${S} (per Node resolution algorithm)
	bun run build || die
}

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r dist package.json

	# CLI entry point
	fperms +x "/usr/lib/node_modules/${PN}/dist/cli/index.js"
	dosym "../lib/node_modules/${PN}/dist/cli/index.js" \
		"/usr/bin/oh-my-opencode-slim"
}

pkg_postinst() {
	einfo "oh-my-opencode-slim installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  \"/usr/lib/node_modules/${PN}/dist/index.js\""
}
