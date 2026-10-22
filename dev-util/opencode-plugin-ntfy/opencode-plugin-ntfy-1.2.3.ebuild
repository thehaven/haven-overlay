# Copyright 2026 Gentoo Authors
# Distributed under the terms GNU General Public License v2

EAPI=8

inherit bun

NPM_PKG="opencode-ntfy.sh"

DESCRIPTION="ntfy.sh push notifications for OpenCode"
HOMEPAGE="https://github.com/lannuttia/opencode-ntfy.sh#readme"
# Upstream stopped publishing to npm after 1.1.0: tags v1.2.0 to v1.2.3 exist on
# GitHub only, so every release past 1.1.0 404s on the registry and the bump
# stage rolls the package back. Build from the release tag archive with the
# repo's own bun.lock instead. src_install then runs "npm pack", which
# reproduces exactly what upstream's "npm publish" uploads, so the runtime
# dependency tree is still resolved from the registry at install time.
SRC_URI="https://github.com/lannuttia/opencode-ntfy.sh/archive/refs/tags/v${PV}.tar.gz -> ${P}.tgz"
S="${WORKDIR}/opencode-ntfy.sh-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND="net-libs/nodejs[npm]"
RDEPEND="net-libs/nodejs"

src_install() {
	# bun_src_compile (bun.eclass) already ran "bun install
	# --frozen-lockfile" and "bun run build", so dist/ exists; pack it.
	local tarball
	tarball="$(npm pack --ignore-scripts --quiet)" || die "npm pack failed"
	npm install --audit false --global --omit dev \
		--prefix "${ED}/usr" "${S}/${tarball}" || die
	# Smoke test: plugin entry present with resolved deps
	# (catches the extract-only anti-pattern — deps must come from npm,
	# not bogus dev-nodejs/* atoms)
	local mod="/usr/$(get_libdir)/node_modules/${NPM_PKG}"
	[[ -f "${ED}${mod}/dist/index.js" ]] || die "plugin entry dist/index.js missing"
}
