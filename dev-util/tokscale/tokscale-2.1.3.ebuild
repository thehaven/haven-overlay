# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Token usage tracking CLI for AI agents"
HOMEPAGE="https://github.com/junhoyeo/tokscale"
SRC_URI="https://github.com/junhoyeo/tokscale/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )
	dev-vcs/git
	dev-lang/rust"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/tokscale-${PV}"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die

	einfo "Building tokscale..."
	cargo build --release -p tokscale-cli || die
}

src_install() {
	dobin target/release/tokscale
	einstalldocs
}

pkg_postinst() {
	einfo "tokscale installed. Run 'tokscale --help' to get started."
}
