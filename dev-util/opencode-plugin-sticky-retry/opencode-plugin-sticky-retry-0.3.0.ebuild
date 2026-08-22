# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bun

DESCRIPTION="Configurable sticky retry plugin for OpenCode"
HOMEPAGE="https://github.com/ronanhansel/opencode-sticky-retry"
SRC_URI="https://github.com/ronanhansel/opencode-sticky-retry/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/opencode-sticky-retry-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

RDEPEND="dev-util/opencode"

src_install() {
	local libdir="$(get_libdir)"
	insinto "/usr/${libdir}/node_modules/${PN}"
	doins -r dist package.json

	# Smoke test: verify plugin entry dist/index.js present
	[[ -f "${ED}/usr/${libdir}/node_modules/${PN}/dist/index.js" ]] || \
		die "plugin entry dist/index.js missing"

	dodoc README.md
}

pkg_postinst() {
	einfo "OpenCode Sticky Retry plugin installed."
	einfo "To enable, add to opencode.json:"
	einfo "  \"/usr/$(get_libdir)/node_modules/${PN}/dist/index.js\""
}
