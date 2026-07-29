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
RDEPEND="
	dev-util/opencode
	net-libs/nodejs
"

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

	# bin/    : upstream CLI wrapper carrying the node shebang.
	# dist/   : compiled plugin loaded by OpenCode (entry = dist/opencode-plugin.mjs).
	# package.json : module manifest read by the OpenCode plugin loader.
	doins -r bin dist package.json

	# The MY_NODE_D vendor tarball extracted ${WORKDIR}/node_modules/ —
	# a sibling of ${S} so bun's walk finds it during src_compile.
	# Re-home it under the package install root for CLI runtime so node
	# module resolution from bin/crewbee.js → dist/src/cli/... walks up
	# and locates deps like 'yaml'.
	doins -r "${WORKDIR}/node_modules"

	# bin/crewbee.js: top-level CLI entry. It require()s dist/src/cli/index.js
	# and the resulting chain resolves node_modules/ via the standard walk.
	fperms +x "/usr/${libdir}/node_modules/${PN}/bin/crewbee.js"
	dosym "../${libdir}/node_modules/${PN}/bin/crewbee.js" \
		"/usr/bin/crewbee"
}

pkg_postinst() {
	einfo "crewbee installed as an OpenCode plugin asset layer."
	einfo ""
	einfo "The 'crewbee' CLI is available. Internally it runs"
	einfo "  npm install --prefix ~/.cache/opencode/ crewbee@latest"
	einfo "to fetch a fresh copy into the OpenCode user workspace, then patches"
	einfo "~/.config/opencode/opencode.json."
	einfo ""
	einfo "Recommended bootstrap:"
	einfo "  crewbee setup --with-opencode"
}
