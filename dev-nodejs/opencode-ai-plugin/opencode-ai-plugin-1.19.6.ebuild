# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@opencode-ai/plugin"
inherit npm

DESCRIPTION="OpenCode plugin SDK — base types/helpers (Plugin, tool schema, TUI) for OpenCode plugins"
HOMEPAGE="https://github.com/anomalyco/opencode"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# The npm tarball ships dist/ + package.json without node_modules. Bun
# install pulls the transitive deps (zod, effect, @ai-sdk/provider,
# @opencode-ai/sdk) at build time — RESTRICT="network-sandbox" OPENS
# network for src_compile so bun install can reach the registry. Runtime
# resolution is then a pure offline fs lookup.
RESTRICT="network-sandbox"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND=">=net-libs/nodejs-20"

src_compile() {
	cd "${S}" || die
	# No --frozen-lockfile: upstream ships no bun.lock or package-lock.json.
	bun install --ignore-scripts || die "bun install failed"
}