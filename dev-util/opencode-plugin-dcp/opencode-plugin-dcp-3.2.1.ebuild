# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin for dynamic context pruning"
HOMEPAGE="https://github.com/Tarquinen/opencode-dynamic-context-pruning"
SRC_URI="https://registry.npmjs.org/@tarquinen/opencode-dcp/-/opencode-dcp-${PV}.tgz -> ${P}.tgz"
S="${WORKDIR}/package"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND="net-libs/nodejs[npm]"
RDEPEND="net-libs/nodejs"

src_compile() { :; }

src_install() {
	npm install --audit false --global --omit dev \
		--prefix "${ED}/usr" "${DISTDIR}/${P}.tgz" || die

	# Patch TUI setup deadlock, autoUpdate default, and inotify watcher loop:
	# 1. lib/v2/tui.tsx: Remove blocking client.status() RPC call from setup()
	# 2. dist/index.js: Disable autoUpdate by default and stub startAutoUpdate
	# 3. dist/index.js: Make PromptStore.ensureDefaultFiles() a no-op to prevent
	#    writing templates into ~/.config/opencode on every startup (which triggers
	#    OpenCode inotify watcher and causes infinite reconciliation storms)
	pushd "${ED}/usr/$(get_libdir)/node_modules/@tarquinen/opencode-dcp" > /dev/null || die
	eapply "${FILESDIR}/${P}-fix-stall-and-watcher-loop.patch" || die
	popd > /dev/null || die
}
