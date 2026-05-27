# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV:0:4}-${PV:4:2}-${PV:6:2}"

inherit multiprocessing

DESCRIPTION="A Rust compiler front-end for IDEs — LSP server for Rust (source build)"
HOMEPAGE="https://rust-analyzer.github.io https://github.com/rust-lang/rust-analyzer"
SRC_URI="https://github.com/rust-lang/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox mirror"

BDEPEND="|| ( dev-lang/rust dev-lang/rust-bin )"

src_configure() {
	export CARGO_HOME="${WORKDIR}/cargo_home"
	mkdir -p "${CARGO_HOME}" || die
	cat > "${CARGO_HOME}/config.toml" <<- EOF || die
	[build]
	jobs = $(makeopts_jobs)
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
	einfo "rust-analyzer ${MY_PV} installed (source build)."
	einfo "opencode auto-detects rust-analyzer on PATH for .rs files."
	einfo ""
	einfo "For explicit control, add to ~/.config/opencode/opencode.json lsp section:"
	einfo "  \"rust-analyzer\": {"
	einfo "    \"command\": [\"/usr/bin/nice\", \"/usr/bin/rust-analyzer\"]"
	einfo "  }"
	einfo ""
	einfo "Requires dev-lang/rust or dev-lang/rust-bin and a Cargo.toml to activate."
}
