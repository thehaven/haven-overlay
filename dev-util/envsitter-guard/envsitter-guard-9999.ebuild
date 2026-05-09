# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin that prevents agents from reading sensitive .env files"
HOMEPAGE="https://github.com/boxpositron/envsitter-guard"
SRC_URI="https://github.com/boxpositron/envsitter-guard/archive/refs/heads/main.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/envsitter-guard-main"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die

	einfo "Building envsitter-guard..."
	bun run build || die
}

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r dist package.json
}

pkg_postinst() {
	einfo "envsitter-guard installed."
}
