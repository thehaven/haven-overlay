# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_PKG="opencode-pty"

DESCRIPTION="OpenCode PTY plugin for live interactive pseudoterminals"
HOMEPAGE="https://github.com/shekohex/opencode-pty"
SRC_URI="https://registry.npmjs.org/${NPM_PKG}/-/${NPM_PKG}-${PV}.tgz -> ${P}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

BDEPEND="net-libs/nodejs[npm]"
RDEPEND="net-libs/nodejs"

src_compile() { :; }

src_install() {
	npm install --audit false --global --omit dev \
		--prefix "${ED}/usr" "${DISTDIR}/${P}.tgz" || die

	# Dual V1/V2 entrypoint: upstream dist/index.js only exports named
	# symbols ({ PTYPlugin, server }); OpenCode V2 requires a default export
	# of the shape { id, setup|effect } and rejects the package otherwise.
	# Patch in a default export while keeping the V1 `server` export so one
	# install serves both runtimes. See the patch header for details.
	pushd "${ED}/usr/$(get_libdir)/node_modules/${NPM_PKG}" > /dev/null || die
	eapply "${FILESDIR}/${P}-dual-entrypoint.patch" || die
	popd > /dev/null || die

	# Root entrypoint shim. OpenCode V2 resolves a plugin *directory* by
	# require.resolve()-ing "<dir>/server" then "<dir>/index" (the `x0`
	# resolver in the opencode2 binary), then reading that module's
	# `default`; it does NOT fall back to a nested dist/ entrypoint for a
	# bare directory, so without this the package is silently dropped from
	# the V2 plugin set. The shim re-exports the dual V1/V2 entrypoint;
	# V2 reads `default`, V1 behaviour is unchanged.
	insinto "/usr/$(get_libdir)/node_modules/${NPM_PKG}"
	newins "${FILESDIR}/${P}-server-shim.js" server.js

	# Smoke test: verify runtime deps installed (catches extract-only
	# ebuilds that skip npm install and ship zero deps — the original
	# "Cannot find package 'open'" error)
	local depdir="${ED}/usr/$(get_libdir)/node_modules/${NPM_PKG}/node_modules"
	for dep in open bun-pty @opencode-ai/sdk @opencode-ai/plugin; do
		[[ -d "${depdir}/${dep}" ]] || \
			die "Plugin ${NPM_PKG} missing dep: ${dep}"
	done
}

pkg_postinst() {
	einfo "OpenCode PTY plugin installed."
	einfo "To use this plugin, add to your opencode.json:"
	einfo "  \"/usr/$(get_libdir)/node_modules/${NPM_PKG}/dist/index.js\""
}
