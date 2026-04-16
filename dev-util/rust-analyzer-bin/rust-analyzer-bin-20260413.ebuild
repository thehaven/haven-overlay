# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Rust compiler front-end for IDEs — LSP server for Rust"
HOMEPAGE="https://rust-analyzer.github.io https://github.com/rust-lang/rust-analyzer"

# Upstream uses date-based tags; PV is YYYYMMDD
MY_DATE="${PV:0:4}-${PV:4:2}-${PV:6:2}"
BASE_URI="https://github.com/rust-lang/rust-analyzer/releases/download/${MY_DATE}"
SRC_URI="
	amd64? (
		elibc_glibc? ( ${BASE_URI}/rust-analyzer-x86_64-unknown-linux-gnu.gz -> ${P}-amd64-glibc.gz )
		elibc_musl?  ( ${BASE_URI}/rust-analyzer-x86_64-unknown-linux-musl.gz -> ${P}-amd64-musl.gz )
	)
	arm64? (
		${BASE_URI}/rust-analyzer-aarch64-unknown-linux-gnu.gz -> ${P}-arm64.gz
	)
"

S="${WORKDIR}"
LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror strip"

BDEPEND="app-arch/gzip"

QA_PREBUILT="usr/bin/rust-analyzer"

src_unpack() {
	local src
	case ${ARCH} in
		amd64)
			if use elibc_musl; then
				src="${DISTDIR}/${P}-amd64-musl.gz"
			else
				src="${DISTDIR}/${P}-amd64-glibc.gz"
			fi
			;;
		arm64) src="${DISTDIR}/${P}-arm64.gz" ;;
		*) die "Unsupported architecture: ${ARCH}" ;;
	esac
	gzip -dc "${src}" > "${WORKDIR}/rust-analyzer" || die
	chmod +x "${WORKDIR}/rust-analyzer" || die
}

src_install() {
	dobin rust-analyzer
}

pkg_postinst() {
	einfo "rust-analyzer ${MY_DATE} installed."
	einfo "opencode will auto-detect rust-analyzer for .rs files."
	einfo ""
	einfo "rust-analyzer requires a Rust toolchain (dev-lang/rust or dev-lang/rust-bin)"
	einfo "and a project-level rust-project.json or Cargo.toml to activate."
}
