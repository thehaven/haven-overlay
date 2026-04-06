# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The open source AI coding agent"
HOMEPAGE="https://opencode.ai https://github.com/anomalyco/opencode"

BUN_V="1.3.11"
BUN_BASE="https://github.com/oven-sh/bun/releases/download/bun-v${BUN_V}"
SRC_URI="
	https://github.com/anomalyco/opencode/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	amd64? (
		cpu_flags_x86_avx2? ( ${BUN_BASE}/bun-linux-x64.zip -> bun-${BUN_V}-amd64.zip )
		!cpu_flags_x86_avx2? ( ${BUN_BASE}/bun-linux-x64-baseline.zip -> bun-${BUN_V}-amd64-baseline.zip )
	)
	arm64? ( ${BUN_BASE}/bun-linux-aarch64.zip -> bun-${BUN_V}-arm64.zip )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="cpu_flags_x86_avx2"

# bun install needs network for node_modules;
# build.ts fetches models.dev/api.json at compile time
RESTRICT="network-sandbox test strip"

BDEPEND="app-arch/unzip"

QA_PREBUILT="usr/bin/opencode"

src_unpack() {
	default

	# Place bun binary on PATH for the build
	local bun_dir
	if use amd64; then
		if use cpu_flags_x86_avx2; then
			bun_dir="${WORKDIR}/bun-linux-x64"
		else
			bun_dir="${WORKDIR}/bun-linux-x64-baseline"
		fi
	elif use arm64; then
		bun_dir="${WORKDIR}/bun-linux-aarch64"
	fi
	chmod +x "${bun_dir}/bun" || die
	export PATH="${bun_dir}:${PATH}"
}

src_compile() {
	cd "${WORKDIR}/${P}" || die

	einfo "Installing dependencies with bun..."
	bun install --frozen-lockfile || die "bun install failed"

	einfo "Building opencode binary (this compiles a standalone executable)..."
	cd packages/opencode || die
	OPENCODE_VERSION="${PV}" \
	OPENCODE_CHANNEL="stable" \
		bun run script/build.ts --single || die "build failed"
}

src_install() {
	cd "${WORKDIR}/${P}/packages/opencode" || die

	# Find the compiled binary
	local bin
	bin=$(find dist -name opencode -type f -executable | head -1)
	[[ -n "${bin}" ]] || die "compiled binary not found in dist/"

	dobin "${bin}"
}

pkg_postinst() {
	einfo "opencode ${PV} installed (built from source with Bun)."
	einfo ""
	einfo "Quick start:"
	einfo "  cd /your/project && opencode"
	einfo ""
	einfo "Set ANTHROPIC_API_KEY, OPENAI_API_KEY, or configure"
	einfo "~/.config/opencode/config.json for your preferred provider."
}
