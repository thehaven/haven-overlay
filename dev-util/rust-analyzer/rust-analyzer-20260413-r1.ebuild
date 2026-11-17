# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV:0:4}-${PV:4:2}-${PV:6:2}"

inherit multiprocessing

DESCRIPTION="Rust LSP server — source build"
HOMEPAGE="https://rust-analyzer.github.io https://github.com/rust-lang/rust-analyzer"
SRC_URI="https://github.com/rust-lang/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox mirror"

BDEPEND="|| ( dev-lang/rust dev-lang/rust-bin )"

# This source provider and dev-util/rust-analyzer-bin both install
# /usr/bin/rust-analyzer, so they must never be installed together. The hard
# blocker refuses the emerge up front instead of dying later on a portage
# file-collision check.
RDEPEND="${BDEPEND} !!dev-util/rust-analyzer-bin"

src_configure() {
	export CARGO_HOME="${WORKDIR}/cargo_home"
	mkdir -p "${CARGO_HOME}" || die
	cat > "${CARGO_HOME}/config.toml" <<- EOF || die
	[build]
	jobs = $(get_makeopts_jobs $(($(get_nproc) + 1)))
	incremental = false

	[term]
	verbose = true
	EOF
}

src_compile() {
	cargo build --release --bin rust-analyzer || die
}

src_install() {
	dobin "${S}/target/release/rust-analyzer"
	einstalldocs
}

pkg_postinst() {
	einfo "rust-analyzer ${MY_PV}: LSP server for Rust — works with OpenCode"
}