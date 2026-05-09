# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="omo; the best agent harness for OpenCode"
HOMEPAGE="https://github.com/code-yeongyu/oh-my-openagent"
SRC_URI="https://github.com/code-yeongyu/oh-my-openagent/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/oh-my-openagent-${PV}"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die

	einfo "Building oh-my-openagent..."
	bun run build || die
}

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r dist package.json
}

pkg_postinst() {
	einfo "oh-my-openagent installed."
}
