# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="1.3.14"
DESCRIPTION="Fast all-in-one JavaScript runtime, bundler, transpiler, and package manager"
HOMEPAGE="https://bun.sh https://github.com/oven-sh/bun"

BUN_BASE="https://github.com/oven-sh/bun/releases/download/bun-v${MY_PV}"
SRC_URI="
	amd64? (
		cpu_flags_x86_avx2? (
			elibc_glibc? ( ${BUN_BASE}/bun-linux-x64.zip -> ${P}-amd64.zip )
			elibc_musl? ( ${BUN_BASE}/bun-linux-x64-musl.zip -> ${P}-amd64-musl.zip )
		)
		!cpu_flags_x86_avx2? (
			elibc_glibc? ( ${BUN_BASE}/bun-linux-x64-baseline.zip -> ${P}-amd64-baseline.zip )
			elibc_musl? ( ${BUN_BASE}/bun-linux-x64-musl-baseline.zip -> ${P}-amd64-musl-baseline.zip )
		)
	)
	arm64? (
		elibc_glibc? ( ${BUN_BASE}/bun-linux-aarch64.zip -> ${P}-arm64.zip )
		elibc_musl? ( ${BUN_BASE}/bun-linux-aarch64-musl.zip -> ${P}-arm64-musl.zip )
	)
"
S="${WORKDIR}"

LICENSE="MIT LGPL-2"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64"
IUSE="cpu_flags_x86_avx2"

RESTRICT="mirror strip"

BDEPEND="app-arch/unzip"
PDEPEND="app-eselect/eselect-bun"

QA_PREBUILT="usr/bin/bun*"

src_install() {
	# Find the extracted bun binary (directory name varies by variant)
	local bin
	bin=$(find "${S}" -maxdepth 2 -name bun -type f | head -n 1)
	[[ -n "${bin}" ]] || die "bun binary not found in workdir"

	newbin "${bin}" "bun-${SLOT}"
	dosym "bun-${SLOT}" "/usr/bin/bunx-${SLOT}"
}

pkg_postinst() {
	eselect bun update ifunset
}

pkg_postrm() {
	eselect bun update ifunset
}
