# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The open source AI coding agent"
HOMEPAGE="https://opencode.ai https://github.com/anomalyco/opencode"
SRC_URI="https://github.com/anomalyco/opencode/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+nodejs +ruff +shfmt +uv clang deno elixir gleam go rust terraform zig"

# bun install needs network for node_modules;
# build.ts fetches models.dev/api.json at compile time
RESTRICT="network-sandbox test strip"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="
	dev-vcs/git
	clang?     ( llvm-core/clang )
	deno?      ( dev-lang/deno-bin )
	elixir?    ( dev-lang/elixir )
	gleam?     ( dev-lang/gleam )
	go?        ( dev-lang/go dev-go/gopls )
	nodejs?    ( net-libs/nodejs )
	ruff?      ( dev-util/ruff )
	rust?      ( || ( dev-lang/rust dev-lang/rust-bin ) dev-util/rust-analyzer-bin )
	shfmt?     ( dev-util/shfmt )
	terraform? ( || ( app-admin/terraform app-admin/opentofu ) dev-util/terraform-ls )
	uv?        ( dev-python/uv )
	zig?       ( dev-lang/zig )
	!dev-util/opencode-bin
"

QA_PREBUILT="usr/bin/opencode"

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
	bin=$(find dist -name opencode -type f -executable | head -n 1)
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
	einfo ""
	einfo "Additional tools opencode can use if installed (not gated by USE flags):"
	einfo "  Formatters (npm/project-local): prettier, biome"
	einfo "  LSP servers (npm): typescript-language-server, pyright,"
	einfo "    vue-language-server, svelte-language-server, yaml-language-server,"
	einfo "    bash-language-server, @astrojs/language-server, intelephense"
	einfo "  LSP servers (other): lua-language-server (auto-downloaded),"
	einfo "    jdtls (auto-downloaded, requires dev-java/openjdk:21)"
	einfo "  MCP servers launched via npx/uvx at runtime -- see opencode.json."
}
