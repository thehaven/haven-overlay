# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV}"
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

LICENSE="MIT LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="cpu_flags_x86_avx2"

RESTRICT="mirror strip"

BDEPEND="app-arch/unzip"

QA_PREBUILT="usr/bin/bun"

S="${WORKDIR}"

src_install() {
	# Find the extracted bun binary (directory name varies by variant)
	local bin
	bin=$(find "${S}" -maxdepth 2 -name bun -type f | head -1)
	[[ -n "${bin}" ]] || die "bun binary not found in workdir"

	dobin "${bin}"

	# bunx is a symlink to bun
	dosym bun /usr/bin/bunx
}

pkg_postinst() {
	einfo "Bun ${PV} installed."
	einfo ""
	einfo "  bun init        -- scaffold a new project"
	einfo "  bun install     -- install dependencies"
	einfo "  bun run <file>  -- execute TypeScript/JavaScript"
	einfo "  bun build       -- bundle for production"
	einfo "  bunx <pkg>      -- execute a package (like npx)"
}
