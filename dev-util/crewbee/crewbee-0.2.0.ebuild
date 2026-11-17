# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bun

DESCRIPTION="CrewBee: open-source AI Agent Team framework and asset layer for OpenCode"
HOMEPAGE="https://github.com/CrewBeeLab/CrewBee"
SRC_URI="https://github.com/CrewBeeLab/CrewBee/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/CrewBee-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

RDEPEND="
	dev-util/opencode
	net-libs/nodejs
"

# CrewBee ships package-lock.json (npm format) rather than bun.lock.
# bun 1.3.x cannot migrate npm lockfiles (verified 2026-08-04 on
# rulesync/openspec; the stash layout breaks non-hoisted transitive
# deps), so drop the lockfile and let bun resolve fresh. This replaces
# the former MY_NODE_D pre-bundled node_modules tarball — source-based
# dependency resolution per overlay policy.
src_compile() {
	rm -f package-lock.json || die
	bun install --ignore-scripts || die "bun install failed"
	bun run build || die
}

src_install() {
	local libdir="$(get_libdir)"
	insinto "/usr/${libdir}/node_modules/${PN}"

	# bin/    : upstream CLI wrapper carrying the node shebang.
	# dist/   : compiled plugin loaded by OpenCode (entry = dist/opencode-plugin.mjs).
	# package.json : module manifest read by the OpenCode plugin loader.
	# node_modules : resolved by bun install in src_compile — re-homed under
	#                the package root so CLI/node resolution walks up to it.
	doins -r bin dist package.json node_modules

	fperms +x "/usr/${libdir}/node_modules/${PN}/bin/crewbee.js"
	dosym "../${libdir}/node_modules/${PN}/bin/crewbee.js" \
		"/usr/bin/crewbee"

	# Smoke test: bin symlink + executable target
	[[ -L "${ED}/usr/bin/crewbee" ]] || die "/usr/bin/crewbee missing"
	[[ -x $(realpath "${ED}/usr/bin/crewbee") ]] || \
		die "/usr/bin/crewbee target is not executable"
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
