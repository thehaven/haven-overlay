# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_PKG="bash-language-server"

DESCRIPTION="A language server for Bash"
HOMEPAGE="https://www.npmjs.com/package/bash-language-server"
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

	# Smoke test: verify the bin symlink exists and its target is executable
	# (catches the pre-bundled MY_NODE_D anti-pattern regression — npm's
	# global install resolves the 9 runtime deps itself)
	local bindir="${ED}/usr/bin"
	[[ -L "${bindir}/bash-language-server" ]] || \
		die "npm install did not create /usr/bin/bash-language-server"
	[[ -x $(realpath "${bindir}/bash-language-server") ]] || \
		die "/usr/bin/bash-language-server target is not executable"
}

pkg_postinst() {
	einfo "bash-language-server ${PV}: LSP server for shell scripts — works with OpenCode"
	einfo "Binary: /usr/bin/bash-language-server"
}
