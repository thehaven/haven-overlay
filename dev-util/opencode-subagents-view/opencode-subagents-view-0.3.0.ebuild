# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bun

DESCRIPTION="OpenCode TUI plugin adding a live 'Subagents' panel to the session sidebar"
HOMEPAGE="https://github.com/giovannic96/opencode-subagents-view"
SRC_URI="https://registry.npmjs.org/${PN}/-/${PN}-${PV}.tgz -> ${P}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# The native libopentui.so in @opentui/core-linux-x64 is x64-only, and the
# plugin itself only declares engines.opencode >= 1.17.0. Skip tests (none
# upstream) and strip (Bun FFI loads the .so unstripped in some flows).
RESTRICT="network-sandbox test strip"

# Source-based deps (replaces former MY_NODE_D mirror tarball pattern).
# Upstream ships no lockfile (package.json `files: ["src"]`), so the
# default `bun install --frozen-lockfile` in the eclass cannot be used;
# we run a plain `bun install` and pin exact resolved versions in the
# ebuild source tree.
src_compile() {
	rm -f package-lock.json bun.lock
	bun install --ignore-scripts || die "bun install failed"
}

# The plugin entry `./tui` → `src/tui.tsx` is loaded at OpenCode startup;
# the runtime resolves its imports (solid-js, @opentui/solid, @opentui/core)
# from this node_modules tree.
#
# @opentui/core-linux-x64-musl is pruned because we don't ship the musl
# variant; @opentui/core-linux-x64 is kept (libopentui.so loads via Bun FFI
# on glibc). The other @opentui/core-* platform variants are optional-dep
# filtered out by bun for linux-x64-glibc.
src_install() {
	local module_dir="/usr/$(get_libdir)/node_modules/${PN}"

	insinto "${module_dir}"
	doins -r src package.json LICENSE README.md

	# Install node_modules into a /node_modules/ subdirectory so the plugin
	# tree keeps its expected layout (plugin imports resolve upward through
	# node_modules/ to find transitive deps like solid-js, @opentui/...).
	insinto "${module_dir}/node_modules"
	doins -r "${S}/node_modules/."

	rm -rf "${ED}${module_dir}/node_modules/@opentui/core-linux-x64-musl" \
		|| die "failed to prune core-linux-x64-musl"

	# @msgpackr-extract ships both glibc and musl native bindings for
	# linux-x64; prune the musl variants so we don't ship unresolvable
	# soname dependencies (libc.so without an absolute path). The glibc
	# .node files stay; the runtime uses them via the appropriate loader.
	find "${ED}${module_dir}/node_modules" -type f -name '*.musl.node' -delete \
		|| die "failed to prune musl .node files"

	# Smoke checks — fail the install if the closure is broken.
	[[ -f ${ED}${module_dir}/src/tui.tsx ]] \
		|| die "plugin entry src/tui.tsx missing"
	[[ -f ${ED}${module_dir}/node_modules/solid-js/package.json ]] \
		|| die "solid-js not installed"
	[[ -f ${ED}${module_dir}/node_modules/@opentui/solid/package.json ]] \
		|| die "@opentui/solid not installed"
	[[ -f ${ED}${module_dir}/node_modules/@opentui/core-linux-x64/libopentui.so ]] \
		|| die "libopentui.so missing"
	[[ ! -d ${ED}${module_dir}/node_modules/@opentui/core-linux-x64-musl ]] \
		|| die "core-linux-x64-musl should be pruned"
}

# libopentui.so is a prebuilt Zig artifact from the @opentui/core-linux-x64
# npm package — strip/QA warnings are expected and harmless.
QA_PREBUILT="*"

pkg_postinst() {
	einfo "${PN} ${PV} installed."
	einfo "To enable, add the plugin to ~/.config/opencode/opencode.json (or"
	einfo "~/.config/opencode/tui.json) on the user that runs OpenCode:"
	einfo "  { \"plugin\": [\"${PN}\"] }"
	einfo ""
	einfo "Requires:"
	einfo "  - dev-util/opencode (>= 1.17.0, declared by upstream engines)"
	einfo "  - dev-lang/bun-bin (>= 1.3.14; loads libopentui.so via FFI)"
}
