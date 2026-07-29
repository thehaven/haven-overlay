# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_D="crewbee-node_modules-${PV}"

DESCRIPTION="CrewBee: open-source AI Agent Team framework and asset layer for OpenCode"
HOMEPAGE="https://github.com/CrewBeeLab/CrewBee"
SRC_URI="
	https://github.com/CrewBeeLab/CrewBee/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/${MY_NODE_D}.tar.xz
"
S="${WORKDIR}/CrewBee-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

# CrewBee ships package-lock.json (npm format) rather than bun.lock, so
# `bun install --frozen-lockfile` (used by bun.eclass) cannot be applied
# directly. The node_modules/ tree required for the build is provided via
# the MY_NODE_D vendor tarball and resolved by bun's normal module walk.
src_compile() {
	bun run build || die
}

src_install() {
	local libdir="$(get_libdir)"
	insinto "/usr/${libdir}/node_modules/${PN}"
	doins -r dist package.json

	# CLI entry point used by `crewbee setup`, `crewbee doctor`, etc.
	fperms +x "/usr/${libdir}/node_modules/${PN}/dist/src/cli/index.js"
	dosym "../${libdir}/node_modules/${PN}/dist/src/cli/index.js" \
		"/usr/bin/crewbee"
}

pkg_postinst() {
	einfo "crewbee installed as an OpenCode plugin asset layer."
	einfo ""
	einfo "To enable it in OpenCode, register the plugin in"
	einfo "  ~/.config/opencode/opencode.json"
	einfo "by adding:"
	einfo "  { \"plugin\": [\"crewbee\"] }"
	einfo ""
	einfo "For full OpenCode integration (config patching, doctor checks,"
	einfo "session binding), run:"
	einfo "  crewbee setup --with-opencode"
}
