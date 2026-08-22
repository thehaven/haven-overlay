# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="JIT skill router for AI agents — routes tasks to 3-5 skills, zero LLM calls"
HOMEPAGE="https://github.com/theshubh007/agent-skill-finder"
SRC_URI="https://registry.npmjs.org/${PN}/-/${PN}-${PV}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# npm install --global fetches the 9 runtime deps from the registry at
# install time, so the network sandbox must be opened for this package.
RESTRICT="network-sandbox"

BDEPEND=">=net-libs/nodejs-20[npm]"
RDEPEND=">=net-libs/nodejs-20"

src_compile() { :; }

src_install() {
	npm install --audit false --global --omit dev \
		--prefix "${ED}/usr" "${DISTDIR}/${P}.tgz" || die

	# Smoke test: verify both bin symlinks exist and their targets are
	# executable (catches the pre-bundled MY_NODE_D anti-pattern regression —
	# npm's global install resolves the runtime deps itself)
	local bindir="${ED}/usr/bin"
	[[ -L "${bindir}/asf" ]] || \
		die "npm install did not create /usr/bin/asf"
	[[ -x $(realpath "${bindir}/asf") ]] || \
		die "/usr/bin/asf target is not executable"
	[[ -L "${bindir}/agent-skill-finder" ]] || \
		die "npm install did not create /usr/bin/agent-skill-finder"

	einstalldocs
}

pkg_postinst() {
	einfo "agent-skill-finder ${PV}: JIT skill router for AI agents"
	einfo "Binaries: /usr/bin/asf, /usr/bin/agent-skill-finder"
	einfo ""
	einfo "Build a skill index from your registries:"
	einfo "  asf ingest --sources ./skills --out ~/.asf"
	einfo "Install a hook into an AI CLI (e.g. claude):"
	einfo "  asf install claude"
}