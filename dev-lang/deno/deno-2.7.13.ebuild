# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo

DESCRIPTION="A secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://deno.land"
SRC_URI="https://github.com/denoland/deno/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Deno build is extremely heavy and requires specific rust/llvm toolchains.
# This ebuild uses the standard cargo eclass patterns.
# Note: For production use, the -bin version is often preferred due to build time.
RESTRICT="network-sandbox"

BDEPEND="
	>=dev-lang/rust-1.80
	dev-build/cmake
	dev-vcs/git
"

src_compile() {
	# Deno requires a specific build command usually via cargo
	cargo_src_compile
}

src_install() {
	dobin "${S}/target/release/deno"
	einstalldocs
}
