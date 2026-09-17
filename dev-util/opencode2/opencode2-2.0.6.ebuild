# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bun

DESCRIPTION="The open source AI coding agent (v2 line, installed as opencode2)"
HOMEPAGE="https://opencode.ai https://github.com/anomalyco/opencode"
SRC_URI="
	https://github.com/anomalyco/opencode/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

# Upstream v2 tags live in the same repository as v1 and extract to
# opencode-${PV}/ (the v2 CLI moved to packages/cli/).
S="${WORKDIR}/opencode-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="+nodejs +ruff +shfmt +uv clang deno elixir gleam go rust terraform zig"

RESTRICT="network-sandbox test strip"

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
"

QA_PREBUILT="usr/bin/opencode2"

src_compile() {
	einfo "Installing dependencies with bun..."
	bun install --ignore-scripts || die "bun install failed"

	einfo "Building opencode v2 binary (this compiles a standalone executable)..."
	# Channel MUST be "v2" (not "stable") so opencode2 isolates its database
	# and background service (~/.local/share/opencode/opencode-v2.db and
	# ~/.local/state/opencode/service-v2.json) and never applies v2 migrations
	# to v1's opencode-stable.db.
	OPENCODE_VERSION="${PV}" \
	OPENCODE_CHANNEL="v2" \
		bun run packages/cli/script/build.ts --single --skip-install || die "build failed"
}

src_install() {
	cd "${S}"/packages/cli || die

	# The v2 build script compiles to dist/opencode-<os>-<arch>/bin/opencode.
	local bin
	bin=$(find dist -path '*/bin/opencode' -type f -executable | head -n 1)
	[[ -n "${bin}" ]] || die "compiled binary not found in dist/"

	# Install as opencode2 so it coexists with dev-util/opencode (v1).
	# Both binaries read the same ~/.config/opencode configuration.
	newbin "${bin}" opencode2
}

pkg_postinst() {
	einfo "opencode2 ${PV} (v2 beta line) installed as /usr/bin/opencode2."
	einfo ""
	einfo "This is the OpenCode v2 beta; it shares ~/.config/opencode with"
	einfo "the v1 dev-util/opencode package and installs alongside it."
	einfo "State and database are isolated under OPENCODE_CHANNEL=v2"
	einfo "(~/.local/share/opencode/opencode-v2.db, service-v2.json)."
	einfo ""
	einfo "Quick start:"
	einfo "  cd /your/project && opencode2"
	einfo ""
	einfo "Plugins targeting the v2 plugin API (e.g."
	einfo ">=dev-util/oh-my-opencode-slim-2.2.11) require this package."
}
