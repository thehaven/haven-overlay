# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Token usage tracking CLI for AI agents"
HOMEPAGE="https://github.com/junhoyeo/tokscale"
SRC_URI="https://github.com/junhoyeo/tokscale/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test strip"

BDEPEND="
	dev-vcs/git
	dev-lang/rust
"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/tokscale-${PV}"

src_compile() {
	# Rust CLI build; the former MY_NODE_D tarball was never consumed by the
	# build, so it is dropped. network-sandbox opens network for crates.io.
	cargo build --release -p tokscale-cli || die
}

src_install() {
	dobin target/release/tokscale
	einstalldocs
}

pkg_postinst() {
	einfo "tokscale installed. Run 'tokscale --help' to get started."
}
