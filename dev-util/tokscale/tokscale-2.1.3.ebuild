# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_D="tokscale-node_modules-2.1.3"

DESCRIPTION="Token usage tracking CLI for AI agents"
HOMEPAGE="https://github.com/junhoyeo/tokscale"
SRC_URI="
	https://github.com/junhoyeo/tokscale/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/${MY_NODE_D}.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	|| ( dev-lang/bun-bin dev-lang/bun )
	dev-vcs/git
	dev-lang/rust
"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/tokscale-${PV}"

src_compile() {
	cargo build --release -p tokscale-cli || die
}

src_install() {
	dobin target/release/tokscale
	einstalldocs
}

pkg_postinst() {
	einfo "tokscale installed. Run 'tokscale --help' to get started."
}
